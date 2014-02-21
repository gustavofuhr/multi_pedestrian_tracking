% 
% Computes the displacement in the wcs using the not updated gpoint
% 
% USAGE
%  wd_vector = compute_world_displacement(tracker, H)
%
function wd_vector = compute_world_displacement(tracker, H)

gpoint_a = tracker.gpoint; % this value needs to be updated
gpoint_b = patch_ground_point(tracker.patches(end), H);

wd_vector = gpoint_b - gpoint_a;

