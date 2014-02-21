% 
% USAGE
%   plot_bboxes(bboxes, color_b)
% 
function plot_bboxes(bboxes, color_b)

if nargin == 1
    color_b = 'r';
end

hold on;
for i = 1:size(bboxes,1)
    b = bboxes(i,:);
    
    plot([b(1), b(1), b(3), b(3), b(1)], [b(2), b(4), b(4), b(2), b(2)], '-', 'Color', color_b, 'LineWidth', 2.0);
end
