function [synced_spikes, templateDepths] = Multi_file_ephys_sync(path,number_of_trials)
% Multi_file_ephys_sync returns binned spike count for all kilosort
% detected neurons and the depth of these neurons
% Input: the directory with all ephys files inside and the number of trials 
% Output: 
% Synced_spikes - Binned spikes for individual trials
% templateDepths - Depths of all templates (neurons)

%move to the directory path
cd(path)
%% kilosort data
kilosort_path = [path 'kilosort\'];
spike_timings   = readNPY([kilosort_path 'spike_times.npy']); %read Kilosort spike timings
spike_times     = double(spike_timings)/30000; %get the spike timings in s
single_spikes   = readNPY([kilosort_path 'spike_clusters.npy']); %cluster IDs
%% get spike depths with a helper function
%you need Spikes for ephys data analysis for this to work
addpath(kilosort_path)
load rez
winv = readNPY('whitening_mat.npy');
ycoords = rez.ycoords;
spikeTemplates = readNPY('spike_templates.npy');
tempScalingAmps = readNPY('amplitudes.npy');
temps = readNPY('templates.npy');
[spikeAmps, spikeDepths, templateDepths, tempAmps, tempsUnW, templateDuration, waveforms] = templatePositionsAmplitudes(temps, winv, ycoords, spikeTemplates, tempScalingAmps);
%templateDepth contains all spike depths

%% get times for all spikes
%     synced_spikes = zeros(numel(templateDepths),numel(frame_timings));
spikes = cell(1,numel(templateDepths));
for template_id = 0:(numel(templateDepths)-1)
    idx                     = find(single_spikes==template_id); %get indicies when selected neuron is spiking
    spikes{template_id + 1} = spike_times(idx); % spike times of selected neuron
    disp(["extracting spikes from individual neurons; Current neuron: " + num2str(template_id)]);
end % end template_id loop
%initialise the matrix to store the complete data
synced_spikes = cell(1,number_of_trials);
%% loop over trials and extract spikes/per frame
%trial start time
start = 0;
for trial_n = 1: number_of_trials
    file = dir(['Trial ' num2str(trial_n) '*']);
    frame_timings{trial_n} = double(readNPY([path file.name '\Record Node 122\experiment1\recording1\events\Neuropix-PXI-100.0\TTL_1\timestamps.npy'])); %get frame times
    frame_timings{trial_n}      = frame_timings{trial_n}/30000;
    frame_timings{trial_n}(1:2) = []; %remove the starting pulse
    frame_timings{trial_n}(1:2:numel(frame_timings{trial_n}))     = []; %remove every 2nd event as this is the down phase of the TTL pulse
    continuous_timestamps = readNPY([path file.name '\Record Node 122\experiment1\recording1\continuous\Neuropix-PXI-100.0\timestamps.npy']); %read the neuropixel timestamps
    continuous_timestamps = double(continuous_timestamps)/30000;
    frame_timings{trial_n} = frame_timings{trial_n} - continuous_timestamps(1); %subtract the timestamps because events are counted from the start of acquisition not recordings
    
    %get spikes for each frame - check if they are between two intervals
    %(frames) and to that add the start time (increasing for each trial)
    for neuron = 1: numel(templateDepths)
        for frame = 1:(numel(frame_timings{trial_n}) - 1)
            n_idx              = find(spikes{neuron} >= (frame_timings{trial_n}(frame) + start) & spikes{neuron} < (frame_timings{trial_n}(frame+1) + start)); %get spike indicies that fire during a trial
            synced_spikes{trial_n}(neuron,frame) = numel(n_idx);
        end % end frame loop
        disp(['Trial number: ' num2str(trial_n) ' neuron number: ' num2str(neuron)]);
    end %end neuron loop
    
    start = start + (continuous_timestamps(end)-continuous_timestamps(1));%add to the trial start time
end % end trial number
end % end function
