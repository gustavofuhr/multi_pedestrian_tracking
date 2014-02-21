% 
% USAGE
%  patches = compute_patches_height(patches, options)
%
function patches = compute_patches_height(patches, options)

original_roi  = patches(end).roi;
fpoint = [(original_roi(1,1)+original_roi(1,2))/2; original_roi(2,2)];
% first, using the homography we can compute the the foot point in the wcs
wf_point = ics2wcs([fpoint; 1], options.H);

P = options.K*options.Rt;

X = wf_point(1);
Y = wf_point(2);

for i=1:size(patches,2)
    % center of the patch
    cp = extract_central_point(patches(i));    
    u = cp(1);
    v = cp(2);
    
    % im going to use the equation involving v coordinate because it is
    % less sensible to noise...
    H = (P(2,1)*X + P(2,2)*Y + P(2,4) - P(3,1)*X*v - P(3,2)*Y*v - P(3,4)*v) / (P(3,3)*v - P(2,3));
    patches(i).height = H;
end

