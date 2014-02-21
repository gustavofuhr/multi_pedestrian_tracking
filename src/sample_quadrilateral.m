% 
% USAGE
%  pts = sample_quadrilateral(points, sample_step)
%
function pts = sample_quadrilateral(points, sample_step)

if nargin == 1
    sample_step = 2;
end

p1 = points(:,1); p2 = points(:,4);
n_points = floor(norm(p1 - p2)/sample_step);

if n_points == 1
   pts = points; 
else
    % one side
    step_t = 1/(n_points-1);
    pts_r = [];
    for t=0:step_t:1
        pts_r = [pts_r [t*p1 + (1 - t)*p2]];
    end

    
    % another side
    p1 = points(:,2); p2 = points(:,3);
    pts_l = [];
    for t=0:step_t:1
        pts_l = [pts_l [t*p1 + (1 - t)*p2]];
    end
    
    % sample the lines formed by the two sides
    pts = [];
    p1 = points(:,3); p2 = points(:,4);
    
    n_v_points = floor(norm(p1 - p2)/sample_step);
    step_t = 1/(n_v_points-1);
    for i=1:n_points
        p1 = pts_l(:,i);
        p2 = pts_r(:,i);
        for t=0:step_t:1
            pts = [pts [t*p1 + (1 - t)*p2]];
        end
    end

end

% fprintf('\n%d points were created!\n', size(pts,2));

pts = round(pts);








