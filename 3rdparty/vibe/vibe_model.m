% 
% This function creates the model of the background using the ViBE
% technique
% 
% USAGE
%   [bg_model] = vibe_model(im_background, n_samples, sphere_radius, n_close_samples, p_resampling)
% 
function [bg_model] = vibe_model(im_background, n_samples, sphere_radius, n_close_samples, p_resampling)

[h,w,c] = size(im_background);

if c > 1
    error('Only the grayscale version of ViBe is implemented.');
end

% bg_model.samples        
S = uint8(zeros(h,w,n_samples));

bg_model.n_samples       = n_samples;
bg_model.sphere_radius   = sphere_radius;
bg_model.n_close_samples = n_close_samples;
bg_model.p_resampling    = p_resampling;

neigh = [0 0; -1 0; -1 1; 0 1; 1 1; 1 0; 1 -1; 0 -1; -1 -1]';

for i = 1:h    
    for j = 1:w
        i_sample = 1;
        while i_sample <= n_samples
            % selects one neighboor to create a sample
            r = randi(9);
            p = [i;j]+neigh(:,r);
            
            if in_boundaries(h,w,p)
                bg_model.samples(i,j,i_sample) = im_background(p(1), p(2));                
                i_sample = i_sample + 1;
            end
        end    
    end
end