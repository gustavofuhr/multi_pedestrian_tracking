function [snum] = format_int(d_mask, num)

snum = '';
if d_mask == 1
    snum = sprintf('%d', num);
elseif d_mask == 2
    snum = sprintf('%.2d', num);
elseif d_mask == 3
    snum = sprintf('%.3d', num);
elseif d_mask == 4
    snum = sprintf('%.4d', num);
elseif d_mask == 5
    snum = sprintf('%.5d', num);
elseif d_mask == 6
    snum = sprintf('%.6d', num);
else
    error('The mask size is not valid');
end