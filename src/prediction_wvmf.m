% 
% This function takes the predicted vector and associates a weight
% to it, in order to use these values in the weighted vector median filter
% 
% USAGE
%  [vector, weight] = prediction_wvmf(predicted_vector, best_matchings, patches, gamma)
%
function [vector, weight] = prediction_wvmf(predicted_vector, best_matchings, patches, gamma)

vector = predicted_vector;

Np = size(patches, 2);
vectors = [];
for i=1:Np
    if isfinite(patches(i).match_distance)
        vectors = [vectors patches(i).wd_vector];
    end
end
Np = size(vectors, 2);
distances = compute_vectors_distances(vectors);

% the weight associated to the predicted vector is somewhat different    
m_dist = median(best_matchings);
c = 0.5;

% beta is defined as the minimum distance
beta = min(distances);

% gamma = 0.15 for instance;
weight = c*Np*exp(-( (distances(end)/beta)^2 + (m_dist/gamma)^2));
    