% 
% This function creates a background image using the samples in the
% model
% 
% USAGE
%   [im_background] = vibe_background_image(bg_model)
% 
function [im_background] = vibe_background_image(bg_model)

[h,w,~] = size(bg_model.samples);

im_background = uint8(zeros(h,w));

for i = 1:h
    for j = 1:w
        m = double(bg_model.samples(i,j,:));
        im_background(i,j) = uint8(median(m));
    end
end