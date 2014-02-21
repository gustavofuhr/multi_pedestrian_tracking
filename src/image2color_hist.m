%
% USAGE
%  histogram = image2color_hist(image, options)
%
function histogram = image2color_hist(image, options)

[h,w,c] = size(image);

if c ~= 2
    error('Not a a*b* image!');
end

observations = double(reshape(image, h*w, c, 1));


step = 256/options.n_bins;
b = [0:step:256];

hists = histc(observations, b, 1); % returns c vectors
% the last values (line) of the histogram must be removed.
hists = hists(1:end-1, :);
hists(:,1) = hists(:,1)./sum(hists(:,1)); % normalizes the histogram
hists(:,2) = hists(:,2)./sum(hists(:,2));

histogram = hists;