% 
% Move patches using a translation that was computed in the world
% coordinate system
% 
% USAGE
%  tracker = move_w_vector_wcs(tracker, wd_vector, H)
%
function tracker = move_w_vector_wcs(tracker, wd_vector, H)

% first compute the displacement in the image
roi = tracker.patches(end).roi;
ipoint_a = [(roi(1,1)+roi(1,2))/2; roi(2,2);];
ipoint_b = wcs2ics([tracker.gpoint + wd_vector; 1], H);
ivector  = ipoint_b - ipoint_a;

for i = 1:size(tracker.patches, 2)
    tracker.patches(i).roi = [tracker.patches(i).roi(1,:) + ivector(1); ...
                                    tracker.patches(i).roi(2,:) + ivector(2)];
end