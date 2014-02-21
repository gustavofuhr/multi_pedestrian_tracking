%
% This function terminates the targets that have a bad matching (defined
% by the median value of matching above a threshold) for a given period
% (defined by a window size)
%
% USAGE
%   tracker = terminate_targets(tracker, border_window_size, center_window_size, border_mask)
%
function tracker = terminate_targets(tracker, size_im, options)

border_window_size = options.term_border_temporal_window_size;
center_window_size = options.term_center_temporal_window_size;
border_mask        = options.border_mask;


for i = 1:length(tracker.targets)
    if tracker.targets(i).enable
        % we apply a different tolerance depending if the target is in the
        % borders or the center of image.
        if ~isempty(tracker.targets(i).c_points)
            % I could use an average of the last points
            last_position = round_to_image(tracker.targets(i).c_points(:,end), size_im(1), size_im(2));
            
            if tracker.targets(i).c_points(1,end) < 1 || tracker.targets(i).c_points(1,end) > size_im(2) || ...
                    tracker.targets(i).c_points(2,end) < 1 || tracker.targets(i).c_points(2,end) > size_im(1)
                is_lost = true;
            else
                if border_mask(last_position(2), last_position(1)) == true
                    % near borders
                    is_lost = target_is_lost2(tracker.targets(i).median_match_distance, border_window_size);
                else
                    is_lost = target_is_lost2(tracker.targets(i).median_match_distance, center_window_size);
                end
            end
            
            if length(tracker.targets(i).associated_detections) >= options.term_no_detections_n_frames
                last_ass = tracker.targets(i).associated_detections(end-options.term_no_detections_n_frames+1:end);
                no_detections = sum(last_ass == -1);
                if no_detections == options.term_no_detections_n_frames
                    is_lost = true;
                end
            end
            
            
            if is_lost
                tracker.targets(i).enable = false;
            end
        end
    end
end

end


%% function
function new_point = round_to_image(point, h, w)

new_point = uint16(point);
if point(1) < 1, new_point(1) = 1; end
if point(1) > w, new_point(1) = w; end
if point(2) < 1, new_point(2) = 1; end
if point(2) > h, new_point(2) = h; end
end