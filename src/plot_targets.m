%
% This function plots the targets of a tracker.
%
% USAGE
%  plot_targets(targets, options)
%
% INPUTS
%  targets
%  options - a struct containing the vizualization options:%
%       target_colors  - list of colors for the targets; if empty, will be created
%       plot_target_number - if the target number must be plotted
%       plot_bboxes - if the bounding box containing the patches must be plotted
%       plot_patches - if the patches must be ploted
%       plot_trajectories - plots the target trajectories; if truethe
%           homography is also needed
%
function plot_targets(targets, options)
% colors, plot_target_number, plot_bbox, plot_patches)

n_targets = length(targets);

if ~isfield(options, 'target_colors') || isempty(options.target_colors)
    target_colors = distinguishable_colors(n_targets, 'k');
else
    target_colors = options.target_colors;
end

% this is a bad pratice right here, im computing the prediction vector
% here to plot them updated.
if options.plot_prediction_vector
    my_targets = targets;
    for i = 1:length(my_targets)
        if ~isempty(my_targets(i).last_displacement)
            my_targets(i) = motion_prediction(my_targets(i), options);
        end
    end
end

for i=1:n_targets
    if targets(i).enable
        hold on;
        
        if options.plot_target_number
            tl_x = targets(i).patches(1).roi(1,1);
            tl_y = targets(i).patches(1).roi(2,1);
            
            text(tl_x+4, tl_y-12, num2str(i), 'Color', target_colors(mod(i, size(target_colors,1))+1,:), 'FontSize', 10, ...
                'BackgroundColor', [.2 .2 .2], 'EdgeColor', [.1 .1 .1]);
        end
        
        if options.plot_bboxes
            all_rois = [targets(i).patches.roi];
            bbox(1,1) = min(all_rois(1,:)); bbox(1,2) = max(all_rois(1,:));
            bbox(2,1) = min(all_rois(2,:)); bbox(2,2) = max(all_rois(2,:));
            
            plot([bbox(1,1), bbox(1,2), bbox(1,2), bbox(1,1), bbox(1,1)], ...
                [bbox(2,1), bbox(2,1), bbox(2,2), bbox(2,2), bbox(2,1)], '-', ...
                'Color', target_colors(mod(i, size(target_colors,1))+1,:), 'LineWidth', 2);
            
        end
        
        if options.plot_patches
            plot_patches(targets(i).patches, target_colors(mod(i, size(target_colors,1))+1,:));
        end
        
        if options.plot_trajectories && ~isempty(targets(i).trajectory)
            % first projects the tracjectories in the ground plane to the image
            im_points = wcs2ics([targets(i).trajectory; ones(1,size(targets(i).trajectory, 2))], options.H);
            plot(im_points(1,:), im_points(2,:), '-', 'Color', target_colors(mod(i, size(target_colors,1))+1,:), 'LineWidth', 2);
        end
        
        if options.plot_prediction_vector && ~isempty(my_targets(i).predicted_vector)
            % the prediction vector is obtaine in the world
            gpoint = patch_ground_point(targets(i).patches(end), options.H);
            gpoint = gpoint + my_targets(i).predicted_vector;
            % project back
            ipoint = wcs2ics([gpoint; 1], options.H);
            f_roi = targets(i).patches(end).roi;
            fpoint = [(f_roi(1,1)+f_roi(1,2))/2; f_roi(2,2)];
            
            dvector = ipoint - fpoint;            
            scale_factor = 3;
            quiver(fpoint(1), fpoint(2), dvector(1)*scale_factor, dvector(2)*scale_factor, 'LineWidth', 2.0, 'AutoScale','off', 'Color', 'k');
        end
    end
end


hold off;