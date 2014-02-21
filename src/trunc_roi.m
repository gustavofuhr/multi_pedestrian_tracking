% 
% This function converts the ROI to int and truncates it with
% respect to the size h x h
% 
% USAGE
%   function new_roi = trunc_roi(roi, h, w)
% 
function new_roi = trunc_roi(roi, h, w)

new_roi = uint16(roi);

new_roi(1,1) = max([1, new_roi(1,1)]);
new_roi(1,2) = min([w, new_roi(1,2)]);

new_roi(2,1) = max([1, new_roi(2,1)]);
new_roi(2,2) = min([h, new_roi(2,2)]);