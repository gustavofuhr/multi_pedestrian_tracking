%
% Initializate any new target that is detect in the frame.
% 
% USAGE
%  new_targets = initialization(frame_number, bg_model, options, targets, valid_region_mask)
% 
function new_targets = initialization(bgs, frame_number, bg_model, people_detections, options, targets, valid_region_mask)

debug_init = true;

if isempty(bgs)
    tic; fprintf('Segmenting frame...');
    bgs = bgs_frame(bg_model, frame_number, options);
    toc;
end

im_frame = get_frame(options, frame_number);

bbox = people_detections;
if debug_init
    imshow(im_frame); hold on;
    plot_bboxes(bbox, 'r');

    if nargin == 7 && ~isempty(valid_region_mask)
        imcontour(valid_region_mask, '--r');
    end    
end


%% remove bounding boxes that are not inside the valid region 
i_remove_bboxes = [];

if nargin == 7 && ~isempty(valid_region_mask)
    [h,w,~] = size(im_frame);

    for i = 1:size(bbox,1)
        % take the foot point and see if it is inside the valid region
        b_point = [(bbox(i,1)+bbox(i,3))/2; bbox(i,4)];        
        if ~valid_region_mask(floor(b_point(2)), floor(b_point(1)))
            if debug_init
                plot_bboxes(bbox(i,:), 'g'); hold on;
            end
    
            i_remove_bboxes = [i_remove_bboxes i];            
        end
    end
end


%% removes the ones that are already being tracked        
if nargin >= 6 && ~isempty(targets)
    for i = 1:size(bbox,1)
        b = bbox(i,:);        
        
        for t = 1:length(targets)
            if targets(t).enable
                all_rois = [targets(t).patches.roi];
                t_bbox(1,1) = min(all_rois(1,:)); t_bbox(1,2) = max(all_rois(1,:));
                t_bbox(2,1) = min(all_rois(2,:)); t_bbox(2,2) = max(all_rois(2,:));
                
                t_bbox = trunc_roi(t_bbox, h, w);
                
                bb_intersect = zeros(h,w);
                
                % detection region
                bb_intersect(uint16(b(2)):uint16(b(4)), uint16(b(1)):uint16(b(3))) = ...
                    bb_intersect(uint16(b(2)):uint16(b(4)), uint16(b(1)):uint16(b(3))) + 1;
                
                % target region
                bb_intersect(t_bbox(2,1):t_bbox(2,2), t_bbox(1,1):t_bbox(1,2)) = ...
                    bb_intersect(t_bbox(2,1):t_bbox(2,2), t_bbox(1,1):t_bbox(1,2)) + 1;
                
                bb_intersect = bb_intersect >= 2;
                
                n_pixels_intersect = double(sum(sum(bb_intersect)));
                n_pixels_detections = (b(4) - b(2))*(b(3) - b(1));
                if (n_pixels_intersect/n_pixels_detections > options.init_max_target_overlap)
                    i_remove_bboxes = [i_remove_bboxes i];
                    if debug_init
                        plot_bboxes(bbox(i,:), 'b'); hold on;
                    end
                    break;
                end
            end
        end        
        
    end
end


if ~isempty(i_remove_bboxes)
    new_bbox = [];
    for i = 1:size(bbox, 1)
        if isempty(find(i_remove_bboxes == i)) % if it was not to remove
            new_bbox = [new_bbox; bbox(i,:)];
        end
    end
    bbox = new_bbox;
end

if debug_init
    alpha = 0.60;
    mix = double(repmat(bgs*255, [1 1, 3])).*alpha + double(im_frame).*(1 - alpha);
    imshow(uint8(mix)); hold on;   
end

new_targets = [];
%% create the points
if ~isempty(bbox)    
    %% creates a map of interesction of bounding boxes
    [h,w,c] = size(im_frame);
    bb_intersect = zeros(h,w);
    
    for i=1:size(bbox,1)
        target_bbox  = bbox(i,:);
        utarget_bbox = uint16(target_bbox);
        bb_intersect(utarget_bbox(2):utarget_bbox(4), utarget_bbox(1):utarget_bbox(3)) = ...
            bb_intersect(utarget_bbox(2):utarget_bbox(4), utarget_bbox(1):utarget_bbox(3)) + 1;
    end
    bb_intersect = bb_intersect >= 2;    
    
    
    %% finally, extracts the foot and head point of the targets
    i_target = 1;
    for i=1:size(bbox,1)
        target_bbox  = bbox(i,:);

        utarget_bbox = uint16(target_bbox);
        bg_roi           = bgs(utarget_bbox(2):utarget_bbox(4), utarget_bbox(1):utarget_bbox(3));
        bb_intersect_roi = bb_intersect(utarget_bbox(2):utarget_bbox(4), utarget_bbox(1):utarget_bbox(3));
        
        [valid_target, foot_point, head_point] = init_foot_head_points(target_bbox, bg_roi, bb_intersect_roi, options);
        
        if valid_target
            y_diff = abs(head_point(2) - foot_point(2));            
            
            new_targets(i_target).foot_point   = foot_point;
            new_targets(i_target).head_point   = head_point;
            new_targets(i_target).patch_height = y_diff/options.init_n_patches;
            new_targets(i_target).patch_width  = y_diff*options.init_aspect_ratio;
            new_targets(i_target).init         = false;
            i_target = i_target + 1;
            
            if debug_init
                plot([foot_point(1), head_point(1)], [foot_point(2), head_point(2)], '-b', 'LineWidth', 2.5);
                plot(foot_point(1), foot_point(2), '.r', 'MarkerSize', 16);
                plot(head_point(1), head_point(2), '.r', 'MarkerSize', 16);
            end
        end
    end
end


% DEBUG
fprintf('%d new targets detected\n', length(new_targets));


