%
% Use the detection bounding boxes to, if there is one nearby the target,
% create a vector pointing to that.
%
% USAGE
%  [vector, weight] = detection_wvmf_vector(target, world_detections, search_region, filtered_vector)
%
% INPUTS
%   target - the target to search
%   world_detections - a list of points in the world that corresponds to
%   detections
%   search_region_size - region size (in the wcs) around the target
%   filtered_vector - the displacement vector filtered using WVMF; this is
%   use if more than one detection is obtained within the search region.
function [vector, weight, id_detection] = detection_wvmf_vector(target, world_detections, search_region_size, world_unit, filtered_vector, gamma)

search_radius = convert_unit('m', world_unit, search_region_size);

%% compute the vector
n_detections = size(world_detections, 2);
detection_points = [];
in_detections = [];
for i = 1:n_detections
    d = norm(target.gpoint - world_detections(:,i));
    if d < search_radius
        detection_points = [detection_points world_detections(:,i)];
        in_detections = [in_detections i];
    end
end

if size(detection_points, 2) > 0
%     disp('Found closeby detection');
    
    % if there is more than one vectors takes the one that is most close
    % to the filtered one
    i_min = 1;
    if size(detection_points, 2) > 1
        min_distance = Inf;
        for i=1:size(detection_points,2)
            detection_vector = detection_points(:, i) - target.gpoint;
            d = norm(detection_vector - filtered_vector);
            if d < min_distance
                min_distance = d;
                i_min = i;
                id_detection = in_detections(i);
            end
        end
    else
        id_detection = in_detections;
    end
    
    vector = detection_points(:, i_min) - target.gpoint;
    
    %% assigns the weight. (Temporally this is done using the same approach used
    % for the prediction vector
    all_vectors = [];
    for i=1:size(target.patches, 2)
        if isfinite(target.patches(i).match_distance)
            all_vectors = [all_vectors target.patches(i).wd_vector];
        end
    end
    all_vectors = [all_vectors vector];
    Np = size(all_vectors, 2);
    distances = compute_vectors_distances(all_vectors);
    m_dist = median(target.best_matchings);
    c = 1.0;
    % beta is defined as the minimum distance
    beta = min(distances);
    % gamma = 0.15 for instance;
    weight = c*Np*exp(-( (distances(end)/beta)^2 + (m_dist/gamma)^2));
else
%     disp('No detection found');
    vector = [0;0];
    weight = 0;
    % assign the id of the detection
    id_detection = -1;
    
end


