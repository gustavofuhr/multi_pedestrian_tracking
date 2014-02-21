% 
% USAGE
%  im_frame = get_frame(options, i)
%
function im_frame = get_frame(options, i)

s_image = sprintf('%s%s.%s', options.image_pref, format_int(options.d_mask, i), options.file_ext);
im_frame = imread(s_image);    

