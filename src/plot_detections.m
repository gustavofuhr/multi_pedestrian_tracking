% 
% Plot the detections bounding boxes. If a detection is associated with a
% a target, then uses the target colors
% 
% USAGE
%  plot_detections(bboxes, target_detections, target_colors)
%
function plot_detections(bboxes, target_detections, target_colors)

hold on;
for i = 1:size(bboxes,1)
    b = bboxes(i,:);
    
    idx = find(target_detections == i);
    if length(idx) > 1
        % this is problematic, because a given detection was associated
        % with two or more targets, use a solid black line in this case
        plot([b(1), b(1), b(3), b(3), b(1)], [b(2), b(4), b(4), b(2), b(2)], '-k');
    elseif length(idx) == 1
        color_t = target_colors(mod(idx, size(target_colors,1))+1,:);
        plot([b(1), b(1), b(3), b(3), b(1)], [b(2), b(4), b(4), b(2), b(2)], '--', 'Color', color_t);
    else
        plot([b(1), b(1), b(3), b(3), b(1)], [b(2), b(4), b(4), b(2), b(2)], '--k');%, 'Color', [0.5,0.5,0.5]);
	end
end
