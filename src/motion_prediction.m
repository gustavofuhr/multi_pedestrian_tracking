% 
% Using the last filtered vectors, compute a motion prediction
% uses the Double Exponential Smoothing technique
% returns also the auxiliary variables ss
% 
% USAGE
%  target = motion_prediction(target, options)
%
function target = motion_prediction(target, options)

alpha = options.motion_prior_alpha;

vt = target.last_displacement; 

s1 = alpha*vt + (1 - alpha)*target.last_ss(:,1);
s2 = alpha*s1 + (1 - alpha)*target.last_ss(:,2);

target.predicted_vector = (2 + alpha/(1-alpha))*s1 - (1 + alpha/(1-alpha))*s2;

target.last_ss = [s1 s2];