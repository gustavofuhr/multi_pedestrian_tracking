% 
% It does the conversion from image coordinate system to world coordinate
% system using the homography of the ground plane
% 
% USAGE
%   gpoint = ics2wcs(im_point, H)
%
% INPUTS
%   im_point = image point in homogeneous coordinates
%
% OUTPUT
%   gpoint = a 2D point in the ground plane
function gpoint = ics2wcs(im_point, H)

im_point = double(im_point);

% test if the im_point is a homogeneous coordinate
if (size(im_point,1) ~= 3)
    error('The input point is not an homogeneous coordinate');
end

gpoint      = inv(H)*im_point;
gpoint(1,:) = gpoint(1,:)./gpoint(3,:);
gpoint(2,:) = gpoint(2,:)./gpoint(3,:);
gpoint      = gpoint(1:2,:);
