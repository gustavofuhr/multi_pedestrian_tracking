%
% Initialize all targets that are not yet initialiazed
%
% USAGE
%  function tracker = init_targets(options, frame_number, tracker)
%
function tracker = init_targets(options, frame_number, tracker)

im_frame = get_frame(options, frame_number);

%% computes the patches' locations for each target
for i = 1:length(options.targets)
    if ~options.targets(i).init
        
        % create_patches returns the min and max for both x and y of all the patches
        tracker.targets(i).patches = create_patches(options.targets(i).head_point, ...
            options.targets(i).foot_point, options.targets(i).patch_height, options.targets(i).patch_width);
        
        % compute the patches height in the world coordinate frame
        tracker.targets(i).patches = compute_patches_height(tracker.targets(i).patches, options);
        
        tracker.targets(i).patches = describe_initial_patches(tracker.targets(i).patches, im_frame, options);
        
        % IMPORTANT: I assume that the last patch is the foot
        roi = tracker.targets(i).patches(end).roi;
        tracker.targets(i).w = roi(1,2) - roi(1,1);
        
        % now, I want to know this width in the world coordinate system
        u = [roi(1,1); roi(2,2); 1]; v = [roi(1,2); roi(2,2); 1];
        tracker.targets(i).w_world       = distance_wcs(u, v, options.H);
        tracker.targets(i).gpoint_lr     = ics2wcs([u v], options.H);
        
        tracker.targets(i).gpoint = patch_ground_point(tracker.targets(i).patches(end), options.H);
        tracker.targets(i).trajectory = [tracker.targets(i).gpoint]; %tracjectory in the ground plane
                
        % creates the variables where we store the last displacements and ss
        tracker.targets(i).last_ss = zeros(2,2);
        tracker.targets(i).last_displacement = []; % auxiliary variable
        tracker.targets(i).predicted_vector = []; % auxiliary variable
        
        tracker.targets(i).best_matchings = [];
        
        tracker.targets(i).id_detection = -1;
        tracker.targets(i).enable = true;
        tracker.targets(i).median_match_distance = [];
        tracker.targets(i).c_points = [];
                
        
        tracker.targets(i).associated_detections = [];
    end
end