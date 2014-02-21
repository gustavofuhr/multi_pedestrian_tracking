% 
% This function subtracts the background of an image and updates the model
% 
% The method used here is from:
% O. Barnich, M. Van Droogenbroeck, Vibe: A universal background sub-
% traction algorithm for video sequences, IEEE Transactions on Image
% Processing 20 (6) (2011) 1709–1724.
% 
% USAGE
%  [bgs, model] = bgs_frame(model, ith_frame, options)
%
function [bgs, model] = bgs_frame(model, ith_frame, options)

im_frame = get_frame(options, ith_frame);

[bgs,model] = vibe_foreground(model, rgb2gray(im_frame));




