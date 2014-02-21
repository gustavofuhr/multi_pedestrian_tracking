% 
% USAGE
%  target = scale_w_homography(target, H)
%
function target = scale_w_homography(target, H)

% now move the left and right points of the center of translation
target.gpoint_lr = target.gpoint_lr + repmat(target.wd_vector, [1 2]);

% projects back these left and right point to see the new width
new_corners  = wcs2ics([target.gpoint_lr; ones(1,2)], H);

new_width    = norm(new_corners(:,1) - new_corners(:,2));

scale = new_width/target.w;

% scales all the patches
target = scale_patches(target, scale);
