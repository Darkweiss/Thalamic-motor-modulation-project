function[norm_binned_spikes] = whisker_stimulation(path)
% whisker_stimulation plots a heatmap of firing rate over time so the
% neurons responding to whisker stimulation can be separated from the rest

%read_the_data
%path='C:\Ephys data\Chronic ephys\Chronic_mouse4_383783\Day 6\Whisker stimulation_2021-10-01_14-18-56\Record Node 122\experiment1\recording1\continuous\Neuropix-PXI-100.0\kilosort';
addpath(path);
spike_timings   = readNPY('spike_times.npy'); %read Kilosort spike timings
spike_times     = double(spike_timings)/30000; %get the spike timings in s
single_spikes   = readNPY('spike_clusters.npy'); %cluster IDs

%% get spike depths with a helper function
%you need Spikes for ephys data analysis for this to work and add it's path
%here
addpath('C:\Users\mfbx5lg2\OneDrive - The University of Manchester\PhD project\Code\Spikes - ephys data analysis\spikes-master\analysis');
load rez
winv = readNPY('whitening_mat.npy');
ycoords = rez.ycoords;
spikeTemplates = readNPY('spike_templates.npy');
tempScalingAmps = readNPY('amplitudes.npy');
temps = readNPY('templates.npy');
[spikeAmps, spikeDepths, templateDepths, tempAmps, tempsUnW, templateDuration, waveforms] = templatePositionsAmplitudes(temps, winv, ycoords, spikeTemplates, tempScalingAmps);
%templateDepth contains all spike depths
 
%% bin the data
bin_length = 1;
bins = 0:bin_length:spike_times(end);
%create matrix to hold all the data
binned_spikes =zeros(numel(templateDepths),numel(bins)-1) ;
%% get firing rates for each neuron
for i=1:numel(templateDepths)    
    single_spikes_neuron = single_spikes==i; %booleans where selected neuron is spiking or not
    idx                  = find(single_spikes_neuron); %get indicies when selected neuron is spiking
    spikes               = spike_times(idx); % spike times of selected neuron
        
    for n = 1:numel(bins) - 1
        n_idx              = find(spikes > bins(n) & spikes < bins(n+1)); %get spike indicies that fire during a trial
        binned_spikes(i,n) = numel(n_idx);    
    end % end bin iteration
     i
end

%% plotting
figure
norm_binned_spikes = normr(binned_spikes);
heatmap(norm_binned_spikes)

%% total spikes
for i=1:15
    X(i) = sum(binned_spikes(:,i));
end

end %end function