% 
% Plot all the patches
% 
% USAGE
%   plot_patches(patches, varargin)
%
function plot_patches(patches, varargin)

if nargin == 2    
    color = varargin{1};
else
    color = 'r';
end

for i=1:size(patches, 2)
    roi = patches(i).roi;
    plot([roi(1,1), roi(1,2), roi(1,2), roi(1,1), roi(1,1)], ...
         [roi(2,1), roi(2,1), roi(2,2), roi(2,2), roi(2,1)], '-', 'Color', color, 'LineWidth', 2); hold on; 
end
