% 
% This function plots the displacement vectors of each patch 
% 
% USAGE
%   plot_displacement_vector(target, color)
% 
function plot_displacement_vectors(target, color)

hold on;        
for i=1:size(target.patches, 2)
    origin_point = extract_central_point(target.patches(i));    

    if isfield(target.patches(i), 'd_vector') && ~isempty(target.patches(i).d_vector)
        quiver(origin_point(1), origin_point(2), target.patches(i).d_vector(1), ...
                 target.patches(i).d_vector(2), 'Color', color, 'LineWidth', 2.0); 
    end
end

% if plot_filtered_vector
%     origin_point = extract_central_point(target.patches);    
%     
%     if isfield(target, 'filtered_vector') && ~isempty(target.filtered_vector)   
%         quiver(origin_point(1), origin_point(2), target.filtered_vector(1), ...
%                 target.filtered_vector(2), 'Color', 'k', 'LineWidth', 2.0); 
%     end
% end 
    
hold off;

