% 
% This function rejects the bounding boxes that are not consistent with
% the camera calibration and the aspect ratio in the image
% 
% USAGE
%  new_bboxes = filter_bounding_boxes(bboxes, K, Rt, min_world_height, max_world_height, min_aspect_ratio, max_aspect_ratio)
%
function new_bboxes = filter_bounding_boxes(bboxes, K, Rt, min_world_height, max_world_height, min_aspect_ratio, max_aspect_ratio)

H = Rt2homog(Rt, K);

new_bboxes = [];

for i = 1:size(bboxes,1)    
    bbox = bboxes(i,:);
    %% first estimate the height
    fpoint = [(bbox(1)+bbox(3))/2; bbox(4)];
    % first, using the homography we can compute the the foot point in the wcs
    wf_point = ics2wcs([fpoint; 1], H);

    P = K*Rt;
    
    % the ground point in the world:
    X = wf_point(1);
    Y = wf_point(2);
    
    hpoint = [(bbox(1)+bbox(3))/2; bbox(2)];
    u = hpoint(1); v = hpoint(2);
    
    person_height = (P(2,1)*X + P(2,2)*Y + P(2,4) - P(3,1)*X*v - P(3,2)*Y*v - P(3,4)*v) / (P(3,3)*v - P(2,3));
    
    %% computes the aspect ratio
    y_diff = abs(bbox(2) - bbox(4));
    x_diff = abs(bbox(1) - bbox(3));
    a_ratio = x_diff/y_diff;
    
    %% only includes the box if it's within the limits
    if (a_ratio >= min_aspect_ratio && a_ratio <= max_aspect_ratio ...
            && person_height <= max_world_height && person_height > min_world_height)
        new_bboxes = [new_bboxes; bbox];
    end
    
   
end
    
    
    
    
    
    
    
    