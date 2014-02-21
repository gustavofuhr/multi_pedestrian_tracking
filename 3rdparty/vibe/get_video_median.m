clc; close all; clear;

%% parameters
options.image_pref = '/home/gfuhr/phd/datasets/oxford/TownCentre_frames/';
options.image_pref = '/media/sda8/phd/datasets/oxford/TownCentre_frames/';
options.image_pref = '/media/sda8/phd/datasets/pets/Crowd_PETS09/S2/L1/Time_12-34/View_001/frame_';
options.d_mask = 4;
options.file_ext = 'jpg';
options.begin_frame = 1;
options.end_frame = 20;
options.step_frame  = 2;
out_filename   = 'median_pets.jpg';


image_stack_r = [];
image_stack_g = [];
image_stack_b = [];

count = 1;
for f = options.begin_frame:options.step_frame:options.end_frame
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
imwrite(uint8(median_image), out_filename);