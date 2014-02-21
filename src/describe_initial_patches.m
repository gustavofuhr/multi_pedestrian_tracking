%
% USAGE
%  patches = describe_patches(patches, image, options)
%
% INPUT
%  image - RGB image (conversion will be performed, if needed)
%
function patches = describe_initial_patches(patches, image, options)

if size(image, 3) == 3
    % using the histograms, the image is converted to Lab
    c = makecform('srgb2lab');
    image = applycform(image, c);
    
    image = image(:,:,2:3); % only the color channels
end

for i=1:size(patches,2)
    roi = int16(patches(i).roi);
    roi_image = image(roi(2,1):roi(2,2), roi(1,1):roi(1,2), :);
    
    % extract the features for each patch
    patches(i).hists = image2color_hist(roi_image, options);
end


