% 
% This function computes the foreground map of the frame and updates
% the background model
% 
%  USAGE
function [foreground_map, bg_model] = vibe_foreground(bg_model, im_frame)

[h,w,c] = size(im_frame);

if c > 1
    warning('Only the grayscale version of ViBe is implemented.');
    im_frame = rgb2gray(im_frame);
end

foreground_map = false(h,w);

neigh = [0 0; -1 0; -1 1; 0 1; 1 1; 1 0; 1 -1; 0 -1; -1 -1]';

for i = 1:h
    for j = 1:w
        % compares the pixel to background model
        is = 1;
        count_inlier = 0;
        while count_inlier < bg_model.n_close_samples && is <= bg_model.n_samples
            d = norm(double(im_frame(i,j)) - double(bg_model.samples(i,j,is)));
            if d < bg_model.sphere_radius, count_inlier = count_inlier + 1; end;
            is = is + 1;
        end
        
        % if there is many samples close to the pixels, than is background
        if (count_inlier >= bg_model.n_close_samples)            
            
            % now updates the model, only if its background and according
            % to a probabilit of 1 in p_resampling            
            if randi(bg_model.p_resampling) == 1
                % chose a random sample to replace
                rs = randi(bg_model.n_samples);
                bg_model.samples(i,j,rs) = im_frame(i,j);
            end
            
            % update the neighboring pixel models
            if randi(bg_model.p_resampling) == 1
                % choose randomly the neighbor
                r = randi(9);
                p = [i;j]+neigh(:,r);
                if in_boundaries(h,w,p)
                    % replace a random sample
                    rs = randi(bg_model.n_samples);
                    bg_model.samples(p(1), p(2), rs) = im_frame(i,j);
                end
                
                
            end
        else
            foreground_map(i,j) = true;
        end
        
    end
end