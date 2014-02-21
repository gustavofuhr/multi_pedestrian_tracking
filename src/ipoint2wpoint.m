% 
% USAGE
%   wpoint = ipoint2wpoint(ipoint, P, height)
%
function wpoint = ipoint2wpoint(ipoint, P, height)

Hi = height;

u = ipoint(1);
v = ipoint(2);


% first model using Ax = b
c11 = P(3,1)*u - P(1,1); c12 = P(3,2)*u - P(1,2);
c21 = P(3,1)*v - P(2,1); c22 = P(3,2)*v - P(2,2);

A = [c11 c12; c21 c22];
b = [P(1,3)*Hi + P(1,4) - P(3,3)*Hi*u - P(3,4)*u; ...
     P(2,3)*Hi + P(2,4) - P(3,3)*Hi*v - P(3,4)*v];

% now we find X,Y of the translation
x = inv(A)*b;

wpoint = x;

% another way of doing
% % % % y = b(2) - (c21 * b(1))/c11;
% % % % y = y/(c22 - (c21*c12)/c11);
% % % % x = (b(1) - c12*y)/c11;
% % % % 
% % % % wpoint = [x; y]
