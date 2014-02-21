% 
% Move patches using a single vector
% wf_vector is the filtered world vector
% 
% USAGE
%  target = move_w_vector(target, wf_vector, options)
%
function target = move_w_vector(target, wf_vector, options)

for i = 1:size(target.patches, 2)
    % first of all we need to project the vector using all
    % the patches heights and move them accordly.
    dvector = wvector2ivector(target.patches(i), target, wf_vector, options);
    
    target.patches(i).roi = [target.patches(i).roi(1,:) + dvector(1); ...
                              target.patches(i).roi(2,:) + dvector(2)];
end