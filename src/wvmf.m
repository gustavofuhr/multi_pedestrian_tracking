% 
% Computes the *weighted vector median filter* to combine the information
% of several vectors resulting in a avarage mean robust to outliers
% OPTIONAL: a set of vectors and match distances that could be add to the filter 
%   these could be predicted_vector or any vector 
% 
% USAGE
%  filtered_vector = wvmf(patches, options, varargin)
%
function filtered_vector = wvmf(patches, options, additional_vectors, additional_weights)

%% filter the vectors
% sometimes a patch is outside the image, so it does not take
% part in the computation of the filtered vector
vectors = []; match_distances = [];
n_good_patches = 0;
for i=1:size(patches, 2)
    if isfinite(patches(i).match_distance)
        vectors = [vectors patches(i).wd_vector];
        match_distances = [match_distances patches(i).match_distance];
        n_good_patches = n_good_patches + 1;
    end
end

ws = zeros(n_good_patches, 1);

%% add the additional information, if provided

if nargin == 4 && ~isempty(additional_vectors) && ~isempty(additional_weights)
	vectors = [vectors additional_vectors];
    ws = [ws; additional_weights];
end

%% computes the filtered vector
if size(vectors, 2) == 0
    filtered_vector = [0;0];
else    
    % first of all, we need to compute the sum of distances
    % between each vector to all others
    distances = compute_vectors_distances(vectors);    
    
    % beta is defined as the minimum distance
    beta = min(distances);
    % gamma = 0.15;
    gamma = options.wvmf_gamma;
    
    % for all the existing patches, compute the weigths
    for i = 1:n_good_patches
        ws(i) = exp(-( (distances(i)/beta)^2 + (match_distances(i)/gamma)^2));        
    end
    
    % now compute the filtered vector using all vectors
    p_sum = [0;0];
    for i = 1:size(vectors, 2)
        p_sum = p_sum + ws(i)*vectors(:,i);
    end
    
    filtered_vector = p_sum/sum(ws);    
end

% DEBUG
% % % % debug all vectors with specific weights, give
% % % % anothe label to additional vectors.
% % % origin_point = [0; 0];
% % % 
% % % colors = distinguishable_colors(size(vectors,2)+1, [1 1 1; 0 1 0; 1 1 0]);
% % % lbls = {};
% % % 
% % % for i = 1:size(vectors,2)
% % %     quiver(origin_point(1), origin_point(2), vectors(1,i), vectors(2,i), 'Color', colors(i,:), 'LineWidth', 2.0); hold on;        
% % %     lbls{end+1} = ['t: ', num2str(i), ' w:',num2str(ws(i))];
% % % end
% % % if ~isempty(additional_vectors)
% % %     quiver(origin_point(1), origin_point(2), additional_vectors(1,1), additional_vectors(2,1), 'Color', colors(end,:), 'LineWidth', 2.0);                
% % %     lbls{end+1} = ['detect w:',num2str(additional_weights(1))];
% % % end;
% % % 
% % % % text(vectors(1,end), vectors(2,end), ['w:',num2str(ws(end))]);
% % % % DEBUG
% % % quiver(origin_point(1), origin_point(2), filtered_vector(1), filtered_vector(2), '--k', 'LineWidth', 2.0);    
% % % legend(lbls, 'Location', 'EastOutside');
% % % hold off;
% % % axis([-0.3 0.3 -0.3 0.3])




