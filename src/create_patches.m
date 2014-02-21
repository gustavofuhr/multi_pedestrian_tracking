% 
% Create_patches returns the min and max for both x and y of all the patches
% 
% Note: patches are structures
% 
% USAGE
%  patches = create_patches(hpoint, fpoint, patch_h, patch_w)
%
function patches = create_patches(hpoint, fpoint, patch_h, patch_w)

min_y = min(hpoint(2), fpoint(2));
max_y = max(hpoint(2), fpoint(2));

size_y = max_y - min_y;

% compute the np for the vertical division
n_y_patches = floor(size_y/patch_h);
if n_y_patches == 0
    n_y_patches = 1;
    new_np_y = size_y;
else
    new_np_y = floor(size_y/n_y_patches);
end
rmd_y = mod(size_y, new_np_y);


% plot([fpoint(1), hpoint(1)], [fpoint(2), hpoint(2)], '-b', 'LineWidth', 2);
% compute the central point for each patch
l = cross([hpoint; 1], [fpoint; 1]); %l(1)*x + l(2)*y + l(3) = 0
i_patch = 1;
for i=1:n_y_patches
    cyi = min_y + ((i-1)*new_np_y) + new_np_y/2;
    % then the x coordinate given the y-coordinate is    
    cxi =  (-l(2)*cyi - l(3))/l(1);    
    % the y-size stays the same
    init_y = min_y + ((i-1)*new_np_y);
    end_y  = min_y + (i*new_np_y);
    if i == n_y_patches
        end_y = end_y + rmd_y;
    end
    
    % the x-position can change
    % the width of the patches must depend only on np
    init_x = cxi - (patch_w/2);
    end_x  = cxi + (patch_w/2);   
    
%     plot(cxi, cyi, '.r');
    
    patches(i_patch).roi = [init_x end_x; init_y end_y];
    i_patch = i_patch + 1;
    
end    

% fprintf('%d patches created.\n', i_patch-1);
% plot_patches(patches);
           
    



