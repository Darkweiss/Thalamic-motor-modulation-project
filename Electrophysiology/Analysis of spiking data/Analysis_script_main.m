%%% FULL ANALYSIS SCRIPT

% working folder
work = 'C:\Users\mfbx5lg2\OneDrive - The University of Manchester\PhD project\Experiments\Chronic implants\mouse #5\Analysis\Day 1';
n_landmarks = 8; %enter the number of landmarks
number_of_trials = 7; % enter the number of trials
refined_landmarks = refined;
raw_landmarks = concatinated;
%% prepare spiking data
%requirements: 
% - Kilosort spike sorted data
% - Raw ephys data with body cam frame timings
% This works with any number of trials as long as the individual trial
% folders are named in this convention: 'Trial 1...', 'Trial 2...'

% enter your path where ephys data is located in individual folders along
% with a folder named 'kilosort' storing the kilosort output (end it with
% \) also enter the number of trials
path = 'C:\Ephys data\Chronic ephys\Chronic_mouse5_383780\Day 1 ephys\';


% run this to store frame binned spikes for each trial along with the
% template depths
[synced_spikes, templateDepths] = Multi_file_ephys_sync(path,number_of_trials);
cd(work)
save('ephys','synced_spikes','templateDepths');

%% prepare the body cam data
[final_landmarks] = Prep_3D_coordinates(refined_landmarks,synced_spikes,raw_landmarks);

%% Place cell plots
selected_neurons = [24];
trial_n = 3;
Place_cells(trial_n, selected_neurons, final_landmarks, synced_spikes)

%% Mouse position during a trial plot
for trial = 1:number_of_trials
   Plot_position_trial(trial,final_landmarks,work) 
end