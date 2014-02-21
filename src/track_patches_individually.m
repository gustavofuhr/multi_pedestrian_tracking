%
% Tracks the patches searching in a region that is defined in the world
% coordinate frame
%
% Note: if color histograms are used, the im_frame must be a Lab image
% with only two channels (a and b). This is to avoid recalculation.
%
% USAGE
%  target = track_patches_individually(target, im_frame, options, candidates)
%
function target = track_patches_individually(target, im_frame, options, candidates)

[~,~,c] = size(im_frame);
if c ~= 2
    error('Not a L*a*b* image, aborting...');
end

original_roi  = target.patches(end).roi;
original_foot = [(original_roi(1,1)+original_roi(1,2))/2; original_roi(2,2)];

for i = 1:size(target.patches, 2);
    % for each patch find the matching within the search window
    min_b = Inf;
    best_candidate = zeros(2);
    for c = candidates
        % c_vector is the difference from the target foot and
        % the point candidate
        c_vector = c - original_foot;
        
        modified_roi = [target.patches(i).roi(1,:) + c_vector(1); target.patches(i).roi(2,:) + c_vector(2)];
        
        % only consider the proposed roi if it is within the image size
        if modified_roi(1,1) >= 1 && modified_roi(2,1) >= 1 && modified_roi(1,2) <= size(im_frame,2) ...
                && modified_roi(2,2) <= size(im_frame,1)
            
            m_roi = int16(modified_roi);
            % extracts the portion of the image concerned by the
            % modified_roi
            roi_image = im_frame(m_roi(2,1):m_roi(2,2), m_roi(1,1):m_roi(1,2), :);
            
            c_hists = image2color_hist(roi_image, options);
            b = 0.5*sum(bhattacharyya(target.patches(i).hists, c_hists));
            
            if b < min_b
                min_b = b;
                best_candidate = modified_roi;
            end
        end
    end
    
    % instead of updating the roi of the patch we store the displacement vector
    target.patches(i).d_vector = [best_candidate(1,1) - target.patches(i).roi(1,1); ...
        best_candidate(2,1) - target.patches(i).roi(2,1)];
    % also stores the matching distance
    target.patches(i).match_distance = min_b;
end

target.median_match_distance = [target.median_match_distance median([target.patches.match_distance])];



