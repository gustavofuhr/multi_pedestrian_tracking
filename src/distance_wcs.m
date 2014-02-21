% 
% This function computes the distance between two point in the world
% coordinate system given two 2D points (u and v) in the image plane 
% and the homography H of the plane
% 
% USAGE
%  distance = distance_wcs(u, v, H)
%
function distance = distance_wcs(u, v, H)

u = double(u);
v = double(v);

wu = inv(H)*u;
wu(1) = wu(1)./wu(3);
wu(2) = wu(2)./wu(3);
wu = wu(1:2);

wv = inv(H)*v;
wv(1) = wv(1)./wv(3);
wv(2) = wv(2)./wv(3);
wv = wv(1:2);

distance = norm(wv - wu);

