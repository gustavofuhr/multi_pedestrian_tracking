% 
% Extract the central point of the set of patches
% 
% USAGE
%  central_point = extract_central_point(patches)
%
function central_point = extract_central_point(patches)

rois = [patches.roi];

% get the extreme values
x_min = min(rois(1,:));
x_max = max(rois(1,:));

y_min = min(rois(2,:));
y_max = max(rois(2,:));

central_point = [(x_min+x_max)/2; (y_min+y_max)/2];