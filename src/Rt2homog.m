% 
% Compute an homography using the components of the projection matrix
% 
% USAGE
%   [H] = Rt2homog(Rt, K)
% 
function [H] = Rt2homog(Rt, K)

R1 = Rt(:,1);
R2 = Rt(:,2);
t = Rt(:,4);
H = K*[R1 R2 t];