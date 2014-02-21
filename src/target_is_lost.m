%
% This function defines if the tracker is lost. We define that the tracker
% is lost if see a significant increase in the matching cost of length given
% by the window size parameter
%
% USAGE
%   [is_lost] = target_is_lost(matching_scores, window_size)
function [is_lost] = target_is_lost(matching_scores, window_size)

debug = false;

 if (length(matching_scores) < window_size*2)    
    is_lost = false;
else
    % first of all, we smooth the scores
    if debug, 
        plot(matching_scores,'-b'); hold on;
    end        
    [b, a] = butter(2, 0.30, 'low');
    matching_scores = filter(b, a, matching_scores);
    if debug, plot(matching_scores,'-r'); end
    
    % take the last window_size matching and compute the standard
    % deviation, if small, it means that the the last frames are
    % a new behaviour of the data
%     lstd = std(matching_scores(end-window_size+1:end));
    if debug, fprintf('lstd: %f\n', lstd); end
    lmean = mean(matching_scores(end-window_size+1:end));
    if debug, plot(0:length(matching_scores), lmean, '--k'); end;
    
    % also the last values must be far from the values of
    % the previous values
    bmean = mean(matching_scores(end-window_size*2+1:end-window_size));
    if debug
        plot(0:length(matching_scores), bmean, '--r');
        fprintf('Means difference: %f\n', (lmean - bmean));
    end        
    
    if (lmean - bmean) > 0.10
        is_lost = true;
    else
        is_lost = false;
    end
end