%
% This function decides based on the matching score history of the target, 
% if we need to update the prediction vector. This is done in order to
% ensure that the target is not updated when the tracker has some
% difficulties.
% 
% USAGE
%   [do_update] = do_update_prediction(matching_scores)
% 
function [do_update] = do_update_prediction(matching_scores)

min_n_values = 10;
if length(matching_scores) < min_n_values
    do_update = true;
else
    % the last value is the one to be tested
    last_value = matching_scores(end);
    matching_scores = matching_scores(1:end-1);
    
    med_score = median(matching_scores);

    % the first quartile is the value that for each 25% of the data
    % lay below the value
    % a simple way to calculate this is to compute the median of the
    % value below the median of the whole data
    first_quartile = median(matching_scores(matching_scores < med_score));
    
    % analogous for the third quartile (75%)
    third_quartile = median(matching_scores(matching_scores > med_score));
    
    
    % now compute the interquartile range (IQ)
    iq = third_quartile - first_quartile;
    
    % now test if the last_value is an inlier, mild outlier or extreme
    % outiler, but only in one direction (up)
    upper_inner_fence = third_quartile + 1.5*iq;
    upper_outer_fence = third_quartile + 3*iq;

    if last_value > upper_inner_fence
        do_update = false;
    else
        do_update = true;
    end
end