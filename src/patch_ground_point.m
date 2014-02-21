% 
% USAGE
%   gpoint = patch_ground_point(patch, H)
%
function gpoint = patch_ground_point(patch, H)

roi = patch.roi;
p = [(roi(1,1)+roi(1,2))/2; roi(2,2); 1];

gpoint    = inv(H)*p;
gpoint(1) = gpoint(1)/gpoint(3);
gpoint(2) = gpoint(2)/gpoint(3);
gpoint    = gpoint(1:2);

