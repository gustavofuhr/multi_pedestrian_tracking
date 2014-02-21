% 
% USAGE
%   bboxes = detect_pedestrians(im_frame, method, detection_options)
%
% INPUTS
%   im_frame           - RGB image 
%   method             - 'SVMLatent' or 'Dollar' (usually better)
%   detections_options - options w.r.t the detector
% 
% OUTPUT
%   bboxes - a list (N x 4) of bounding boxes, where N is the number of
%   detections and each bounding box is defined as a 4 column vector
%   [top_left.x top_left.y bottom_right.x bottom_right.y]
% 
function bboxes = detect_pedestrians(im_frame, method, detection_options)

if strcmp(method, 'SVMLatent')
	bboxes = process(im_frame, detection_options.svml_model, detection_options.score_threshold); % detect objects   
    bboxes = bboxes(:, 1:4);
    
elseif strcmp(method, 'Dollar')
    detection_options.imgNm = im_frame;    
    bboxes = detect(detection_options);
    bboxes = bboxes(:, 1:4);
    % we need to convert these bboxes from (x y w h) to (x1 y1 x2 y2)
    bboxes(:,3) = bboxes(:,1)+bboxes(:,3);
    bboxes(:,4) = bboxes(:,2)+bboxes(:,4);    
end