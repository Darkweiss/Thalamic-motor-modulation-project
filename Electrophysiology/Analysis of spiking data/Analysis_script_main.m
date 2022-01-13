%%% FULL ANALYSIS SCRIPT

% working folder where the data is saved
work = 'C:\Users\mfbx5lg2\OneDrive - The University of Manchester\PhD project\Experiments\Chronic implants\mouse #6\Analysis\Day 5';
%directory with body cam .csv files
body_cams = 'C:\Ephys data\Chronic ephys\Chronic_mouse6_383781\bodycams\Day5';
n_landmarks = 9; % enter the number of landmarks
number_of_trials = 7; % enter the number of trials
n_cameras = 4; % enter the number of cameras
landmarks_for_deletion = [];
spike_threshold = 1000; %how many spikes a neuron has to fire to be analysed
video='Camera_1_trial_1_2021-11-10-104115-0000.avi'; %of the first trial

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
ephys_path = 'C:\Ephys data\Chronic ephys\Chronic_mouse6_383781\ephys\Day5\';
% run this to store frame binned spikes for each trial along with the
% template depths
[synced_spikes, templateDepths] = Multi_file_ephys_sync(ephys_path,number_of_trials);
cd(work)
save('ephys','synced_spikes','templateDepths');

%% triangulate the body cam data for SSM
% before using the next function, load your camera matrix as 'P'
[concatinated, separated] = Triangulation_loop(body_cams,P, number_of_trials, n_cameras);
[nan_idx, coordinates_no_nan] = modify_3D(concatinated,landmarks_for_deletion);

[Data_3D_refined,b,T] = main_3D_SSM_reconstruct_luka_v1(coordinates_no_nan);
[final_landmarks] = Prep_3D_coordinates(Data_3D_refined,synced_spikes,nan_idx);
cd(work)
save('3D_landmarks', 'final_landmarks');

%% get coefficients for 3D landmarks
%put data in a cell array so DecomPose_PCA works
final_landmarks = {final_landmarks};
%run PCA on data
Nshape = 3; %number of PC
[vec,val] = DecomPose_PCA(final_landmarks, Nshape);
vec = vec(:,end:-1:end-Nshape+1);
final_landmarks =final_landmarks{1};
%get coefficients
[coeffs, nans] = DecomPose(final_landmarks,video,vec,false,false);


% for i = 1:number_of_trials
%     synced_spikes{i}(:,nans{i}) = [];
%     final_landmarks{i}(:,:,nans{i}) = [];
% end
%% put data in larger bins
[analysis_id,binned_coefficient,binned_spikes] = LargerBins(ephys_path,synced_spikes,coeffs,spike_threshold);

%% locomotion coefficient
[locomotion_coeff] = locomotion(binned_coefficient);
binned_coefficient = [binned_coefficient;locomotion_coeff'];
%% Place cell plots
selected_neurons = [301];
for trial = 1:number_of_trials
    Place_cells(trial, selected_neurons, final_landmarks, synced_spikes)
    title(['Trial ' num2str(trial)])
end
%% Mouse position during a trial plot
for trial = 1:number_of_trials
   Plot_position_trial(trial,final_landmarks,work)
end

%% Bayes tuning curves
pmtrs.prctilelo = 2.5; %low-cutoff for for coefficient
pmtrs.prctilehi = 97.5; %high-cutoff for for coefficient
pmtrs.Nbins = 10; %number of bins for the coefficient
[Eyx,xbc] = tuning_curve_bayes(binned_coefficient(7,:),binned_spikes(analysis_id(3),:),pmtrs);

%% A different approach to tuning curves with a time shift plot
[tuning] = tuning_by_time(binned_coefficient(4,:),binned_spikes(analysis_id(75),:),pmtrs,1000,true)

