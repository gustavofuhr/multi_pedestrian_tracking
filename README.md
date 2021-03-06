Overview
=========

A **multi-pedestrian tracker** as proposed in the paper:

*Führ, G. ; Jung, C. R. Combining Patch Matching and Detection for Robust* 
*Pedestrian Tracking in Monocular Calibrated Cameras. Pattern Recognition Letters* 
*(Special Issue). 2013.*

If you use the following code in our experiments, please cite the above publication.

Videos of the tracker performance and information about it can be found in: http://inf.ufrgs.br/~gfuhr/?file=research
Soon, there will be extensions of the code and improvements in this webpage.

For question about the code/method please contact Gustavo Führ
at gfuhr@inf.ufrgs.br.

Requirements
============

The source code was tested in MATLAB 64-bin in version
7.12 (R2010a) in Linux x64. However, you should not have 
problems in running the code in different platforms and 
newer versions of MATLAB. This applications includes the 
person detector developed by Piotr Dóllar, which can be
found in his personal website. 

Running the code
================
1. Unpack the code
2. Run the main.m file using MATLAB

All the important configurations of the tracker are set in the main.m. This package contains
an example main.m with configurations used in the datasets presented in the paper. 
Please not that you should download the sequences separately.

The folder calibration/ provides the calibration files for the PETS and TownCentre
dataset used in the paper.

Configuration of main.m
=======================
	
- options.init_n_patches 
	The number of patches in which a pedestrian is segmented. (default: 6)
	
- options.init_aspect_ratio 
	This is the aspect_ratio used to compute the width of the patches at
	initialization. (default: 0.26)
	
- options.init_max_target_overlap 
	Maximum allowed ratio of overlap between different detected pedestrians --
	if the overlap is above this value the detections are rejected. (default: 0.01)

- options.init_min_perc_foreground 
	In order to avoid false positives of the person detector, only detections with
	significant amount of background are initialized. This value is the minimum amount
	of background required to consider the detection bounding box. (default: 0.4)

- options.max_world_height
	Maximum height in meters, for a pedestrian, in real-world coordinates. If the height
	of the detected pedestrian is above, the initialization is aborted. This value is used 
	to reject false positives generated by the person detector. (default: 2.5)

- options.min_world_height
	Minimum height in meters, for a pedestrian in real-world coordinates. (default: 1.5)

- options.term_border_temporal_window_size 
	Number of frames in which a target that has been tracked poorly 
	is terminated if the target is (currently) on the borders of the image. (default: 4)

- options.term_center_temporal_window_size 
	Number of frames in which a target that has been tracked poorly 
	is terminated if the target is (currently) on the center of the image. (default: 16)

- options.term_no_detections_n_frames 
	Number of frames after which the track is terminated if no detection was
	associated with the target (Default: 16).

- options.n_bins
	Number of bins used to compute the color histograms. (default: 128)

- options.detection_search_region
	Radius (in meters) of the search region around the target to associate 
	pedestrians detections. (default: 1.5)

- options.s_temporal_window
	Number of past frames used to compute the weight of the detection vector
	in the WVMF. (default: 50)

- options.wvmf_gamma 
	Gamma parameter value for the Weighted Vector Median Filter. See paper
	for details. (default: 0.25)

- options.motion_prior_alpha
	Alpha parameter to compute the motion prediction. See paper for details
	(default: 0.08)
	
- options.world_search_sample_step
	Step size (in pixels) that is used to sample the world candidate region after
	its projection. (default: 1)

- options.walking_speed
	Represents the maximum pedestrian walking speed expected in the sequence in m/s. 
	(default: 1.5)

- options.relaxation_parameter
	Relaxation parameter to increase the size of the search region (usually used to 
	recover from failure). 
	(default: 0.5)

- options.show_frames
	Boolean field to show the results of tracking. (default: true)

- options.plot_bboxes 
	If true, makes it so that bounding boxes are plotted during execution. 
	(default: false)

- options.plot_patches 
	Boolean field that determines whether or not the patches used for tracking
	are displayed. (default: true)

- options.plot_trajectories 
	Variable to decide if pedestrian trajectories are displayed. 
	(default: false)
	
- options.plot_target_number 
	Boolean field that determines whether or not the pedestrian identifier is
	plotted in the result frames. (default: true)	

- options.plot_detections 
	Plot the pedestrian detections with colors that indicate to which target
	they were associated. (default: false)

- options.plot_prediction_vector 
	Plot the projected prediction vector for each target. (default: false)

- options.save_frames 
	Save the frames in the options.out_path folder.
	It requires the package export_fig to work (export_fig can be obtained
	at: http://www.mathworks.com/matlabcentral/fileexchange/23629-exportfig)
	(default: false)

- options.out_filename 
	Character string that represents the name of the output file. 

- options.out_path 
	Path where output files should be stored.

- options.image_pref
	The prefix of the string used to create the filenames.

- options.file_ext
	The file extension of the image files.

- options.d_mask
	The mask of integers used to create the numeric part of the 
	filename. For instance, if the options.image_pref = 'data/fr', options.file_ext = 'png' 
	and options.d_mask = 3, the filenames will be created as 'data/fr001.png', 
	'data/fr002.png', etc.

- options.calib_filename
	The path to the xml file containing the camera calibration. 
	The xml is expected to be in the format provided with the PETS dataset. 
	The calibration/pets.xml in this package is an example of such calibration file.

- options.world_unit
	The measurement unit of the calibration file. The possible values 
	are 'm' (meters), 'cm' (centimeters) and 'mm' (milimeters).

- options.video_fps
	The frames per second of the sequence. This is used when defining 
	the search region in the world. See the papers for details.

- options.begin_frame
	The first frame that will be used in the sequence.

- options.end_frame
	The number of the last frame to be processed.

- options.bg_model_filename 
	The background model file previously stored. Use this file to save the background
	model once it is computed. You can examples of this in the folder bg_models/

- options.init_bg_training 
	If the background model file is not provided, then it is going to be computed at
	initialization. The frame range used begins in init_bg_training and ends at 
	begin_frame.

- options.begin_frame
	The first frame that will be used in the sequence.

- options.end_frame
	The number of the last frame to be processed.
	
Output
======

A file with the trackers results (positions) is stored in a .mat file named with the 
parameter options.out_filename.

Enjoy and please send us feedback!
