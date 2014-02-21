% 
% This function plots the displacement vectors of each patch 
% 
% USAGE
%   plot_3d_displacement_vector(target)
% 
function plot_3d_displacement_vectors(target)

figure('Color', 'w');
half_patch = target.patches(end).height;

for i=1:size(target.patches, 2)
    o_pt = [target.gpoint; target.patches(i).height];
    arrow3d(o_pt, o_pt+[target.patches(i).wd_vector;0]);
end



