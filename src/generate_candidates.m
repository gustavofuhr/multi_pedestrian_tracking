% 
% Generates the candidates in the image using a region specified in
% the world
% 
% USAGE
%  candidates = generate_candidates()
%
function candidates = generate_candidates(target, options, predicted_vector)

pgpoint = patch_ground_point(target.patches(end), options.H);

% if the predicted_vector was computed the search region is centered in
% this point
if nargin == 3 && ~isempty(predicted_vector)
    pgpoint = pgpoint + predicted_vector;
end

corner_pts = world_search_region(pgpoint, options.world_search_radius*2, options.H);

candidates = sample_quadrilateral(corner_pts, options.world_search_sample_step);
