% 
% Compute the displacement vectors in the world coordinate system
% 
% USAGE
%  patches = compute_world_d_vectors(patches, options, gpoint)
%
function patches = compute_world_d_vectors(patches, options, gpoint)

P = options.K * options.Rt;

for i = 1:size(patches, 2)    
    patch_cp = extract_central_point(patches(i));    
    
    wpoint1 = ipoint2wpoint(patch_cp, P, patches(i).height);
    ipoint2 = patch_cp + patches(i).d_vector;
    wpoint2 = ipoint2wpoint(ipoint2, P, patches(i).height);
    
    wvector = wpoint2 - wpoint1;
    
    patches(i).wd_vector = wvector;
end