% 
% USAGE
%  ivector  = wvector2ivector(patch, target, wvector, options)
%
function ivector  = wvector2ivector(patch, target, wvector, options)

P = options.K * options.Rt;

Xpoint = wvector + target.gpoint;


ipoint = P*[Xpoint(1); Xpoint(2); patch.height; 1];
ipoint(1) = ipoint(1)/ipoint(3);
ipoint(2) = ipoint(2)/ipoint(3);

ipoint = ipoint(1:2);

ivector = ipoint - extract_central_point(patch);