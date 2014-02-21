% 
% USAGE
%  bdist = bhattacharyya(histogram1, histogram2)
%
function bdist = bhattacharyya(histogram1, histogram2)

bins = size(histogram1, 1);
c    = size(histogram1, 2); % number of histograms

% TODO: that must be a better way to do that
bdist = [];
for i = 1:c
    bcoeff = 0;
    for j=1:bins    
        bcoeff = bcoeff + sqrt(histogram1(j,i) * histogram2(j,i));
    end
    
    bdist = [bdist sqrt(1 - bcoeff)];
end




