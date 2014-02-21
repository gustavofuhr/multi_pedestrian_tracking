% 
% Take the displacemet information of the patch and update its ROI
% 
% USAGE
%  patches = move_patches_individually(patches)
%
function patches = move_patches_individually(patches)

for i = 1:size(patches,2)
    old_roi = patches(i).roi;
    new_roi = [old_roi(1,:) + patches(i).d_vector(1); ... displacement in x 
                old_roi(2,:) + patches(i).d_vector(2)];
	patches(i).roi = new_roi;
end

