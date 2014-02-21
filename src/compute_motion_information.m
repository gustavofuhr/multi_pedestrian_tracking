%
% saves information that is going to be used to predict a displ. vector
% 
% USAGE
%   target = compute_motion_information(target, options)
%
function target = compute_motion_information(target, options)


best_d = get_best_matching_distance(target.patches, target.filtered_vector);
target.best_matchings = [target.best_matchings best_d];
if size(target.best_matchings, 2) > options.s_temporal_window
    target.best_matchings = target.best_matchings(end-options.s_temporal_window+1:end);
end

target.last_displacement = target.filtered_vector;