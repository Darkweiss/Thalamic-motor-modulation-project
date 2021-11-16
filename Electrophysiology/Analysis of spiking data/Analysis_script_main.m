%%% FULL ANALYSIS SCRIPT

% working folder where the data is saved
work = 'C:\Users\mfbx5lg2\OneDrive - The University of Manchester\PhD project\Experiments\Chronic implants\mouse #6\Analysis\Day 4';
%directory with body cam .csv files
body_cams = 'C:\Ephys data\Chronic ephys\Chronic_mouse6_383781\bodycams\Day4';
n_landmarks = 7; % enter the number of landmarks
number_of_trials = 6; % enter the number of trials
n_cameras = 4; % enter the number of cameras
landmarks_for_deletion = [4];
%refined_landmarks = refined;
%raw_landmarks = concatinated;
%% prepare spiking data
%requirements: 
% - Kilosort spike sorted data
% - Raw ephys data with body cam frame timings
% This works with any number of trials as long as the individual trial
% folders are named in this convention: 'Trial 1...', 'Trial 2...'

% enter your path where ephys data is located in individual folders along
% with a folder named 'kilosort' storing the kilosort output (end it with
% \) also enter the number of trials
ephys_path = 'C:\Ephys data\Chronic ephys\Chronic_mouse6_383781\ephys\Day4\';
% run this to store frame binned spikes for each trial along with the
% template depths
[synced_spikes, templateDepths] = Multi_file_ephys_sync(ephys_path,number_of_trials);
cd(work)
save('ephys','synced_spikes','templateDepths');

%% triangulate the body cam data for SSM
% before using the next function, load your camera matrix as 'P'
[concatinated, separated] = Triangulation_loop(body_cams,P, number_of_trials, n_cameras);
[nan_idx, coordinates_no_nan] = modify_3D(concatinated,landmarks_for_deletion);

[Data_3D_refined,b,T] = main_3D_SSM_reconstruct_luka_v1(concatinated);
[final_landmarks] = Prep_3D_coordinates(Data_3D_refined,synced_spikes,raw_landmarks);
cd(work)
save('3D_landmarks', 'final_landmarks');

%% prepare the spiking data with Larger_bins script

%% Place cell plots
selected_neurons = [23];
for trial = 1:number_of_trials
    Place_cells(trial, selected_neurons, final_landmarks, synced_spikes)
    title(['Trial ' num2str(trial)])
end
%% Mouse position during a trial plot
for trial = 1:number_of_trials
   Plot_position_trial(trial,final_landmarks,work)
end

%% Bayes tuning curves

%% rasmus' coefficient tuning curves
cd(work)
save('coefficients','coeffs');


