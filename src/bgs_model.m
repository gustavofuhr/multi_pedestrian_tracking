% 
% This function is a wrapper to create the model for background subtraction
% 
% The method used here is from:
% O. Barnich, M. Van Droogenbroeck, Vibe: A universal background sub-
% traction algorithm for video sequences, IEEE Transactions on Image
% Processing 20 (6) (2011) 1709–1724.
% 
% because this method needs a background image, one is create using
% the median value of the first n frames.
% 
% USAGE
%  [bgs, model] = bgs_frame(model, ith_frame, options)
%
function model = bgs_model(i_first_frame, i_last_frame, options, step)

if nargin == 3
    step = 1;
end

% creates the median image
image_stack_r = [];
image_stack_g = [];
image_stack_b = [];

count = 1;
for f = i_first_frame:step:i_last_frame
    fprintf('Processing frame %d ', f); tic;
    im_frame = get_frame(options, f);
    
    image_stack_r(:,:,count) = im_frame(:,:,1);
    image_stack_g(:,:,count) = im_frame(:,:,2);
    image_stack_b(:,:,count) = im_frame(:,:,3);
    
    count = count + 1;    
    toc;
end

median_image_r = median(image_stack_r, 3);
median_image_g = median(image_stack_g, 3);
median_image_b = median(image_stack_b, 3);
median_image(:,:,1) = median_image_r;
median_image(:,:,2) = median_image_g;
median_image(:,:,3) = median_image_b;

imshow(median_image/255);
disp('Press a key...');
pause;

n_samples = 20;
sphere_radius = 20;
n_close_samples = 2;
p_resampling = 16;
model = vibe_model(rgb2gray(uint8(median_image)), n_samples, sphere_radius, n_close_samples, p_resampling);


    