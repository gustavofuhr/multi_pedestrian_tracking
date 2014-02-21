% 
% This function extracts the foot and head points for initialization. It
% tries to extract the best line fitting and remove false positives
% 
% USAGE
%   [valid, foot_point, head_point] = init_foot_head_points(bbox, bg_roi, bb_intersect, options)
% 
function [valid, foot_point, head_point] = init_foot_head_points(bbox, bg_roi, bb_intersect, options)

foot_point = [0;0];
head_point = [0;0];

bbox(3) = bbox(3) - 4;

[fg_rows,fg_cols] = find(bg_roi == 1);       
% at least a good pecentage of the bounding box must be
% foregroung
n_foreground = length(fg_rows);
n_bbox = (bbox(4)-bbox(2))*(bbox(3)-bbox(1));

% exclude the bottom part because legs are always moving.
exclude_bottom_perc = 0.3;

% the weight of a intersected foreground pixel, notice the one
% of a non-occluded pixel is 1
w_intersected = 0.0;

if n_foreground > 0  && (n_foreground/n_bbox) > options.init_min_perc_foreground          
    % now tests all the x in the bbox to get the better
    y_fg_min = bbox(2)+max(fg_rows);
    y_fg_max = bbox(2)+min(fg_rows);
            
    max_fg_count = -1; x_foot = -1; y_head = -1; x_head = -1;
            
    for xi = bbox(1):1:bbox(3)
        l = ground_plane_line([xi; y_fg_min], options.K, options.Rt);
        
        % ax + by + c = 0
        % I know the y want to know the x
        % x = (-b*y -c)/a
        fg_count = 0; yi_max = 0; xi_max = 0; yi_min = 0;                
        
        y_start = y_fg_min - (y_fg_min - y_fg_max)*exclude_bottom_perc;
        
        for yi = y_start:-1:y_fg_max
            x_line = (-l(2)*yi -l(3))/l(1);
            % only counts if it is inside bbox.
            y_test = uint16(yi);
            x_test = uint16(x_line);
            
            % if inside the bounding box
            if x_test >= bbox(1) && x_test <= bbox(3) && ...
                    y_test >= bbox(2) && y_test <= bbox(4)
                y_test = y_test - y_fg_max + 1; % NEW: bbox(2) + 1;  
                x_test = x_test - bbox(1) + 1;
                
                % if the point is foreground and if the point is not
                % a point of intersection, count it.
                if bg_roi(y_test, x_test) == 1 
                    yi_max = yi; xi_max = x_line;
                    
                    if bb_intersect(y_test, x_test)
                        fg_count = fg_count + w_intersected; 
                    else
                        fg_count = fg_count + 1; 
                    end
                end
                
            end
            
        end
        
        if fg_count > max_fg_count
            max_fg_count = fg_count;
            x_foot = xi;
            y_foot = bbox(4);
            y_head = yi_max;
            x_head = xi_max;
        end
        
    end
    foot_point = [x_foot; y_foot];
    head_point = [x_head; y_head];
    
    % compute the person height to see if it is in the right range
    wf_point = ics2wcs([foot_point; 1], options.H); P = options.K*options.Rt;    
    X = wf_point(1); Y = wf_point(2); v = head_point(2);
    person_height = (P(2,1)*X + P(2,2)*Y + P(2,4) - P(3,1)*X*v - P(3,2)*Y*v - P(3,4)*v) / (P(3,3)*v - P(2,3));
    
    % options for the boxes rejection
    max_world_height = convert_unit('m', options.world_unit, options.max_world_height);
    min_world_height = convert_unit('m', options.world_unit, options.min_world_height);
            
    % if not a single valid foreground point was found, dont
    % add the target to the system
    if max_fg_count > 0 && person_height >= min_world_height && ...
            person_height <= max_world_height
        valid = true;        
    else
        valid = false;
    end                
else
    valid = false;
end
                