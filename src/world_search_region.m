% 
% This function computes a square search region in the world coordinate 
% system and projects in the image plane using an homography
% TODO: change from square to circle and instead of receive a region size 
% in the world, compute it using the subject speed and video fps
% 
% USAGE
%  s_points = world_search_region(gpoint, square_side, H)
%
function s_points = world_search_region(gpoint, square_side, H)

hs = square_side/2;

w_points = [gpoint - hs, ... lower left
              [gpoint(1) - hs; gpoint(2) + hs], ... upper left
              [gpoint(1) + hs; gpoint(2) + hs], ... upper right
              [gpoint(1) + hs; gpoint(2) - hs]]; ... lower right

% homogeneous coordinates
w_points = [w_points; ones(1, size(w_points,2))];
              
s_points = wcs2ics(w_points, H);
