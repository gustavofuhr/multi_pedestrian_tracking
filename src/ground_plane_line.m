% 
% This function returns the 2D line that correponds to a projection of the
% 3D line orthogonal to the plane. The resulting line is a vector [a,b,c] 
% given in the form of ax + by + c = 0
% 
% USAGE
%  l = ground_plane_line(ground_image_point, K, Rt)
%
function l = ground_plane_line(ground_image_point, K, Rt)

% first, we need to compute the ground point using the ground image point
p = [ground_image_point; 1];
H = Rt2homog(Rt, K);
gpoint    = inv(H)*p;
gpoint(1) = gpoint(1)/gpoint(3);
gpoint(2) = gpoint(2)/gpoint(3);
gpoint    = gpoint(1:2);

% now we use this point to extract a point (e.g. the head)
z = 200;
mp = K*Rt*[gpoint; z; 1];
mp(1) = mp(1)/mp(3);
mp(2) = mp(2)/mp(3);
mp = [mp(1:2); 1];

% the line passing between 2 points (in homogeneous coord.) is the
% cross product between them
l = cross(p, mp);

