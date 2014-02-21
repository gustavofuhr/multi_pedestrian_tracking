function [is_lost] = target_is_lost2(matching_scores, window_size)

n_outliers = 0;
 
if (length(matching_scores) < window_size*2)    
    is_lost = false;
else    
    for i = 1:window_size
        s = [matching_scores(1:end-window_size+i-1) matching_scores(end-window_size+i)];
        if ~do_update_prediction(s)
            n_outliers = n_outliers + 1;
        end
    end
    
    if n_outliers == window_size
        is_lost = true;
    else
        is_lost = false;
    end
end