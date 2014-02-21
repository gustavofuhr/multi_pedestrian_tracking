% 
% Detects pedestrian and computes the points in the ground plane associated
% with these detections
% 
% USAGE
%  [world_people_detections, image_people_detections] = detect_pedestrians_world(im_frame, world_unit, K, Rt, , detection_options)
%
% INPUTS
%   im_frame - RGB image
%   options 
%       world_unit - the unit ('m', 'mm' or 'cm') of calibration
%       R and t - the camera calibration
% 
function [world_people_detections, image_people_detections] = detect_pedestrians_world(im_frame, options) 

if nargin == 4
    opt = struct('modelNm','ChnFtrs01','resize',1,'fast',1);
else
    opt = options.detection_opt;
end
bboxes = detect_pedestrians(im_frame, 'Dollar', opt);

% options for the boxes rejection
max_world_height = convert_unit('m', options.world_unit, options.max_world_height);
min_world_height = convert_unit('m', options.world_unit, options.min_world_height);
min_aspect_ratio = 0.2; max_aspect_ratio = 0.6;

bboxes = filter_bounding_boxes(bboxes, options.K, options.Rt, min_world_height, max_world_height, ...
                                    min_aspect_ratio, max_aspect_ratio);

n_detections = size(bboxes, 1);
world_people_detections = zeros(2, n_detections);

% we are going to need the homography
H = Rt2homog(options.Rt, options.K);

% if the second output argument is requested, return it
if nargout == 2
    image_people_detections = bboxes;
end

% figure; imshow(im_frame); hold on;
for i=1:n_detections
    gpoint_im_x = (bboxes(i,1) + bboxes(i,3)) / 2;
    gpoint_im_y = bboxes(i,4);
    
    world_people_detections(:,i) = ics2wcs([gpoint_im_x; gpoint_im_y; 1], H);    
   
end





