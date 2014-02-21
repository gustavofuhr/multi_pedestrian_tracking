%
% Runs the tracker, what else did you expect?
%
% USAGE
%  run_tracker(options)
%
function run_tracker(options)

%%
im_first_frame = get_frame(options, options.begin_frame);

%% detect targets and initialize them for the first frame
if options.show_frames
    fig_tracker = figure;
end

addpath('./3rdparty/vibe/');
% if no background model is provided, create one
if isfield(options, 'bg_model_filename')
    load(options.bg_model_filename);
else
    tic; fprintf('Building background model...');
    bg_model = bgs_model(options.init_bg_training, options.begin_frame, options, 4); toc;
    disp('Its your chance to save the background model for next time (variable name = bg_model)...');
    keyboard;
end

options.detection_opt = struct('modelNm','ChnFtrs01','resize',2,'fast',1);
if isfield(options, 'init_detection_threshold')
    options.detection_opt.thr = options.init_detection_threshold;
end
addpath('./3rdparty/dollar_detector');


[~, image_people_detections] = detect_pedestrians_world(im_first_frame, options);

options.targets = initialization([], options.begin_frame, bg_model, image_people_detections, options);
options.target_colors = distinguishable_colors(20, 'k');


%% initialize the targets
tracker = init_targets(options, options.begin_frame);
[options.targets.init] = deal(true); % init done.

%% shows the first frame
if options.show_frames
    
    % save the initialization patches
    imshow(im_first_frame); hold on;
    
    plot_targets(tracker.targets, options);
    hold off;
    if options.save_frames
        out_frame = sprintf('%strack%s.png', options.out_path, format_int(options.d_mask, options.begin_frame));
        export_fig(out_frame, '-a2', '-zbuffer');
    end
end

%% define the valid image region for the next initializations
[h,w,~] = size(im_first_frame);
valid_region_perc = 0.4;

options.init_valid_region = false(h,w);
options.init_valid_region(:, 1:valid_region_perc*w) = true;
options.init_valid_region(:, (1-valid_region_perc)*w:end) = true;
options.init_valid_region(1:valid_region_perc*h, :) = true;
options.init_valid_region((1-valid_region_perc)*h:end, :) = true;


%% tracking
i_result = 1;
for f = options.begin_frame+1:options.end_frame
    fprintf('Frame %d of %d\n', f, options.end_frame); tic;
    
    %% read the frame
    im_frame = get_frame(options, f);
    
    %% detects people and find the points in the ground plane
    fprintf('Detecting pedestrians in the frame... '); tic;
    [world_people_detections, image_people_detections] = detect_pedestrians_world(im_frame, options);
    fprintf('%d people detected.', size(world_people_detections, 2)); toc;
    
    %% convert the frame if necessary
    if options.show_frames, im_original_frame = im_frame; end
    
    c = makecform('srgb2lab');
    im_frame = applycform(im_frame, c);
    im_frame = im_frame(:,:,2:3); % only the color channels
    
    %% track all targets
    for t = 1:length(tracker.targets)
        if tracker.targets(t).enable
            fprintf('\tTarget %d...', t);
            
            try
                %% computes the prediction vector if is not the first frame
                if ~isempty(tracker.targets(t).last_displacement) % if we have information to compute
                    if do_update_prediction(tracker.targets(t).median_match_distance)
                        tracker.targets(t) = motion_prediction(tracker.targets(t), options);
                    end
                else
                    tracker.targets(t).predicted_vector = [0; 0];
                end
                
                
                %% generate candidates and move each patch individually using the world search region
                candidates = generate_candidates(tracker.targets(t), options, tracker.targets(t).predicted_vector);
                tracker.targets(t) = track_patches_individually(tracker.targets(t), im_frame, options, candidates);
                
                %% compute the displacement vectors in the world coordinate system
                tracker.targets(t).patches = compute_world_d_vectors(tracker.targets(t).patches, options, tracker.targets(t).gpoint);
                
                
                %% if requested, add more vectors to the WVM filter
                additional_vectors = []; additional_weights = [];
                if ~isempty(tracker.targets(t).best_matchings)
                    [v, w] = prediction_wvmf(tracker.targets(t).predicted_vector, tracker.targets(t).best_matchings, ...
                        tracker.targets(t).patches, options.wvmf_gamma);
                    additional_vectors = [additional_vectors v];
                    additional_weights = [additional_weights; w];
                end
                
                if ~isempty(tracker.targets(t).best_matchings)
                    if do_update_prediction(tracker.targets(t).median_match_distance)  %if occluded dont trust this vector
                        filtered_vector = wvmf(tracker.targets(t).patches, options, additional_vectors, additional_weights);
                        [detect_vector, detect_weight, tracker.targets(t).id_detection] = detection_wvmf_vector(tracker.targets(t), world_people_detections, ...
                            options.detection_search_region, options.world_unit, filtered_vector, ...
                            options.wvmf_gamma);
                        
                        if tracker.targets(t).id_detection ~= -1
                            additional_vectors = [additional_vectors detect_vector];
                            additional_weights = [additional_weights; detect_weight];
                        end
                    else
                        tracker.targets(t).id_detection = -1;
                    end
                    
                    tracker.targets(t).associated_detections = [tracker.targets(t).associated_detections tracker.targets(t).id_detection];
                end
                
                %% applies the WVMF to the set of individual displacements
                tracker.targets(t).filtered_vector = wvmf(tracker.targets(t).patches, options, additional_vectors, additional_weights);
                
                %% move patches using the resulting vector
                tracker.targets(t) = move_w_vector(tracker.targets(t), tracker.targets(t).filtered_vector, options);
                
                %% update the gpoint in the world
                tracker.targets(t).wd_vector  = tracker.targets(t).filtered_vector;
                tracker.targets(t).gpoint     = tracker.targets(t).gpoint + tracker.targets(t).wd_vector;
                tracker.targets(t).trajectory = [tracker.targets(t).trajectory tracker.targets(t).gpoint];
                tracker.targets(t).c_points   = [tracker.targets(t).c_points extract_central_point(tracker.targets(t).patches)];
                
                %% scale the patch using the homography
                tracker.targets(t) = scale_w_homography(tracker.targets(t), options.H);
                
                %% save stuff for prediction
                tracker.targets(t) = compute_motion_information(tracker.targets(t), options);
                
                %% save the results
                res(i_result).targets(t).id = t;
                res(i_result).targets(t).n_candidates = length(candidates);
                res(i_result).targets(t).patches = tracker.targets(t).patches;
                res(i_result).targets(t).c_point = extract_central_point(tracker.targets(t).patches);
                
                all_rois = [tracker.targets(t).patches.roi];
                bbox(1,1) = min(all_rois(1,:)); bbox(1,2) = max(all_rois(1,:));
                bbox(2,1) = min(all_rois(2,:)); bbox(2,2) = max(all_rois(2,:));
                
                res(i_result).targets(t).bbox   = bbox;
                res(i_result).targets(t).enable = true;
                
                fprintf('done.\n');
            catch err
                tracker.targets(t).enable = false;
            end
        else
            res(i_result).targets(t).enable = false;
        end
    end
    
    
    %% init any new targets
    new_targets = initialization([], f, bg_model, image_people_detections, options, tracker.targets, options.init_valid_region);
    options.targets = [options.targets new_targets];
    tracker = init_targets(options, f, tracker);
    [options.targets.init] = deal(true); % init done.
    
    %% terminate bad targets
    if ~isfield(options, 'border_mask')
        options.border_mask = define_image_borders(options.K*options.Rt, size(im_frame), 2.0, options.world_unit, 0.5);
    end
    tracker = terminate_targets(tracker, size(im_frame), options);
    
    %% plot result frame
    if options.show_frames
        imshow(im_original_frame); hold on;
        plot_targets(tracker.targets, options);
        if options.plot_detections
            plot_detections(image_people_detections, [tracker.targets.id_detection], options.target_colors);
        end
        
        if options.save_frames
            out_frame = sprintf('%strack%s.png', options.out_path, format_int(options.d_mask, f));
            export_fig(out_frame, '-a2', '-zbuffer');
        else
            pause(0.1);
        end
        hold off;
    end
    
    i_result = i_result + 1;
    toc; fprintf('\n');
end

frames = [options.begin_frame:options.end_frame];

% also saves the options in the mat file
save([options.out_path, options.out_filename], 'res', 'frames', 'options');
disp('Done!');







