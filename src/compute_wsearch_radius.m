% 
% USAGE
%  radius = compute_wsearch_radius(options)
%
function radius = compute_wsearch_radius(options)

% because the walking_speed is given in ms, maybe we need to
% perform some unit conversion
if strcmp(options.world_unit, 'mm')
    radius = (options.walking_speed*1000)/options.video_fps;
elseif strcmp(options.world_unit, 'cm')
    radius = (options.walking_speed*100)/options.video_fps;
elseif strcmp(options.world_unit, 'm')
    radius = (options.walking_speed)/options.video_fps;
end

% now the relaxation
radius = radius + radius*options.relaxation_parameter;