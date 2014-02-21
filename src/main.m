% SCRIPT
clc; close all; clear;
format long;
dataset = 'pets';

%% options for the initialization
options.init_n_patches           = 6;
options.init_aspect_ratio        = 0.26;   
options.init_max_target_overlap  = 0.01;
options.init_min_perc_foreground = 0.4;

%% options for the boxes rejection
options.max_world_height = 2.5; 
options.min_world_height = 1.5; % must be in meters

%% options for termination
options.term_border_temporal_window_size = 4;
options.term_center_temporal_window_size = 16;
options.term_no_detections_n_frames      = 16;

%% parameters of the features
options.n_bins = 128;

%% parameters for using detection as feature
options.detection_search_region = 1.5; % in meters
options.s_temporal_window = 50; % the size of the temporal window used

%% gamma parameter for the exponential in the wvmf
options.wvmf_gamma = 0.25;

%% prediction parameters
options.motion_prior_alpha     = 0.08;

%% search region
options.world_search_sample_step = 1;
options.walking_speed = 1.5; % in m/s
options.relaxation_parameter = 0.5;

%% vizualization
options.show_frames              = true;
options.plot_bboxes              = false;
options.plot_patches             = true;
options.plot_trajectories        = false;
options.plot_target_number       = true;
options.plot_detections          = false;
options.plot_prediction_vector   = false;
options.save_frames              = false; 


%% output parameters
options.out_filename = ['results_', dataset, '.mat'];
options.out_path = ['./out/', dataset, '/'];
mkdir(options.out_path);

if strcmp(dataset, 'pets')
    %% pets dataset, automatic init
    options.image_pref        = './datasets/pets/Crowd_PETS09/S2/L1/Time_12-34/View_001/frame_';
    options.calib_filename    = 'calibration/pets_calib.xml';
    options.video_fps         = 7;
    options.world_unit        = 'mm';
    options.d_mask            = 4;
    options.file_ext          = 'jpg';    
    options.bg_model_filename = 'bgmodels/bg_model_pets_110_180.mat';
    options.begin_frame       = 180;
    options.end_frame         = 794;           
elseif strcmp(dataset, 'towncentre')    
    %% towncentre sequence
    options.image_pref        = './datasets/towncentre/frame_';
    options.calib_filename    = 'calibration/towncentre_calib.xml';
    options.world_unit        = 'm';
    options.video_fps         = 25;
    options.d_mask            = 5;
    options.file_ext          = 'png';  
    options.bg_model_filename = 'bgmodels/bg_model_towncentre_1_250.mat';
    options.begin_frame       = 250;
    options.end_frame         = 1000;
end


%%
options = validate_options(options);
disp(options); % shows the options


%% runs the tracker!
run_tracker(options);