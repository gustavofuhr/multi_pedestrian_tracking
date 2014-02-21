% 
% This function uses the ground plane to define borders in the image. This
% is used on the termination scheme.
% 
% INPUTS
%   w_height - world height of the targets (in m)
% USAGE
%   [mask_im] = define_image_borders(P, image_size, w_height, world_unit, aspect_ratio)
% 
function [mask_im] = define_image_borders(P, image_size, w_height, world_unit, aspect_ratio)

h = image_size(1);
w = image_size(2);

mask_im = false(h,w);

H = [P(:, 1:2) P(:, 4)];

w_height = convert_unit('m', world_unit, w_height);

%% south border
for x = 10:10:w
    ifoot_point = [x; h; 1];
    
    wfoot_point = ics2wcs(ifoot_point, H);
    whead_point = [wfoot_point(1); wfoot_point(2); w_height; 1];
    
    ihead_point    = P*whead_point;
    ihead_point(1) = ihead_point(1)/ihead_point(3);
    ihead_point(2) = ihead_point(2)/ihead_point(3);
    
    i_width = norm(ihead_point(1:2) - ifoot_point(1:2))*aspect_ratio;
    
    tl_p = round_to_image([ihead_point(1) - i_width/2.0; ihead_point(2)], h, w);
    br_p = round_to_image([ihead_point(1) + i_width/2.0; h], h, w);
    
    
    mask_im(tl_p(2):br_p(2), tl_p(1):br_p(1)) = true;
    
%     plot([tl_p(1), br_p(1), br_p(1), tl_p(1), tl_p(1)], [tl_p(2), tl_p(2), br_p(2), br_p(2), tl_p(2)], '-r', 'LineWidth', 1.5);
end


%% east border
for y = 1:10:h
    ifoot_point = [w; y; 1];
    
    wfoot_point = ics2wcs(ifoot_point, H);
    whead_point = [wfoot_point(1); wfoot_point(2); w_height; 1];
    
    ihead_point    = P*whead_point;
    ihead_point(1) = ihead_point(1)/ihead_point(3);
    ihead_point(2) = ihead_point(2)/ihead_point(3);
    
    i_width = norm(ihead_point(1:2) - ifoot_point(1:2))*aspect_ratio;
    
    tl_p = round_to_image([ihead_point(1) - i_width; ihead_point(2)], h, w);
    br_p = round_to_image([w; ifoot_point(2)], h, w);
    
    mask_im(tl_p(2):br_p(2), tl_p(1):br_p(1)) = true;
    
%     plot([tl_p(1), br_p(1), br_p(1), tl_p(1), tl_p(1)], [tl_p(2), tl_p(2), br_p(2), br_p(2), tl_p(2)], '-r', 'LineWidth', 1.5);
end


%% west border
for y = 1:10:h
    ifoot_point = [1; y; 1];
    
    wfoot_point = ics2wcs(ifoot_point, H);
    whead_point = [wfoot_point(1); wfoot_point(2); w_height; 1];
    
    ihead_point    = P*whead_point;
    ihead_point(1) = ihead_point(1)/ihead_point(3);
    ihead_point(2) = ihead_point(2)/ihead_point(3);
    
    i_width = norm(ihead_point(1:2) - ifoot_point(1:2))*aspect_ratio;
    
    tl_p = round_to_image([1; ihead_point(2)], h, w);
    br_p = round_to_image([i_width; ifoot_point(2)], h, w);
    
    mask_im(tl_p(2):br_p(2), tl_p(1):br_p(1)) = true;
    
%     plot([tl_p(1), br_p(1), br_p(1), tl_p(1), tl_p(1)], [tl_p(2), tl_p(2), br_p(2), br_p(2), tl_p(2)], '-r', 'LineWidth', 1.5);
end


%% north border
for x = 1:4:w
    ihead_point = [x; 1; 1];
    whead_point = ipoint2wpoint(ihead_point, P, w_height);    
    
    wfoot_point    = [whead_point(1); whead_point(2); 0; 1];
    ifoot_point    = P*wfoot_point;
    ifoot_point(1) = ifoot_point(1)/ifoot_point(3);
    ifoot_point(2) = ifoot_point(2)/ifoot_point(3);
    
    i_width = norm(ihead_point(1:2) - ifoot_point(1:2))*aspect_ratio;
    
    tl_p = round_to_image([x; 1], h, w);
    br_p = round_to_image([x + i_width; ifoot_point(2)], h, w);
    
    mask_im(tl_p(2):br_p(2), tl_p(1):br_p(1)) = true;
    
%     plot([tl_p(1), br_p(1), br_p(1), tl_p(1), tl_p(1)], [tl_p(2), tl_p(2), br_p(2), br_p(2), tl_p(2)], '-r', 'LineWidth', 1.5);
end

end

%% function
function new_point = round_to_image(point, h, w)
    new_point = uint16(point);
    if point(1) < 1, new_point(1) = 1; end
    if point(1) > w, new_point(1) = w; end
    if point(2) < 1, new_point(2) = 1; end
    if point(2) > h, new_point(2) = h; end
end


