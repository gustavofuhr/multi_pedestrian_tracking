% 
% It does the conversion from world coordinate system to image coordinate
% using an homography 
% 
% USAGE
%  im_point = wcs2ics(w_point, H)
%
function im_point = wcs2ics(w_point, H)

w_point = double(w_point);

% test if the im_point is a homogeneous coordinate
if (size(w_point,1) ~= 3)
    error('The input point is not an homogeneous coordinates');
end

im_point      = H*w_point;
im_point(1,:) = im_point(1,:)./im_point(3,:);
im_point(2,:) = im_point(2,:)./im_point(3,:);
im_point      = im_point(1:2,:);
