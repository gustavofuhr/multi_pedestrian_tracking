% 
% USAGE
%  options = validate_options(options)
%
function options = validate_options(options)

% use default values
if ~isfield(options, 's_temporal_window'), options.s_temporal_window = 50; end;

if ~isfield(options, 'n_bins')
    options.n_bins = 128;
end

if ~isfield(options, 'calib_filename')
    error('You need to inform the calibration xml file');
end
    
if isfield(options,'targets') && ~isempty(options.targets)
    [options.targets.init] = deal(false);
end

if ~isfield(options, 'walking_speed'), options.walking_speed = 1.5; end
if ~isfield(options, 'relaxation_parameter'), options.relaxation_parameter = 0.5; end

% vizualization defaults
if ~isfield(options, 'plot_target_number'), options.plot_target_number = false; end
if ~isfield(options, 'plot_bboxes'), options.plot_bboxes = false; end
if ~isfield(options, 'plot_patches'), options.plot_patches = true; end
if ~isfield(options, 'plot_trajectories'), options.plot_trajectories = false; end
if ~isfield(options, 'plot_target_number'), options.plot_target_number = true; end
if ~isfield(options, 'plot_detections'), options.plot_detections = false; end
if ~isfield(options, 'plot_vectors'), options.plot_vectors = false; end
if ~isfield(options, 'plot_prediction_vector'), options.plot_prediction_vector = false; end

% compute some useful stuff
options.world_search_radius = compute_wsearch_radius(options);
[options.K, options.Rt] = parse_xml_calibration_file(options.calib_filename);
options.H = Rt2homog(options.Rt, options.K);


