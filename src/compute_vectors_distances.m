% computes the sum distance from each vector to all others
% 
% USAGE
%  distances = compute_vectors_distances(vectors)
%
function distances = compute_vectors_distances(vectors)

sv = size(vectors, 2);

distances = zeros(1, sv);
for i = 1:sv
    for j = 1:sv
        if i ~= j
            d = norm(vectors(:,i) - vectors(:,j));
            distances(i) = distances(i) + d;
        end
    end
end