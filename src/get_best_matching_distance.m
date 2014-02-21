% 
% Extracts the *matching* distance of the patch that is the closest to the
% computed filtered vector
% 
% USAGE
%  best_distance = get_best_matching_distance(patches, filtered_vector)
% 
function best_distance = get_best_matching_distance(patches, filtered_vector)

distances = zeros(1, size(patches, 2));
min_d = Inf;
i_min = 0;
for i = 1:size(patches,2)
    d = norm(filtered_vector - patches(i).d_vector );
    if d < min_d
        min_d = d;
        i_min = i;
    end
end

best_distance = patches(i_min).match_distance;