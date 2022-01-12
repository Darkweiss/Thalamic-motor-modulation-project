function[analysis_id,binned_coefficient,binned_spikes] = LargerBins(kilosort_folder,spikes,coeffs,spike_threshold)
addpath([kilosort_folder 'kilosort']); %get kilosort folder
load rez
bad_idx = find(rez.good==0); %get the 'bad' kilosort neurons

%concatinate the coeffs and spikes
all_spikes = [];
all_coeffs = coeffs{1};
for trial = 1:size(spikes,2)
    all_spikes = cat(2,all_spikes,spikes{trial});
    %all_coeffs = cat(1,all_coeffs,coeffs{trial});
end

all_spikes(bad_idx,:) = NaN; %remove the 'bad' neurons
[no_spikes_idx] = find(sum(all_spikes,2)< spike_threshold); %remove neurons with less than 1000 spikes
all_spikes(no_spikes_idx,:) =NaN;
analysis_id = find(~isnan(all_spikes(:,1)));
%analysis_id now contains all the good neurons with more than
%spike_threshold spikes

%bin the data to larger bins
bins = 1:10:numel(all_spikes(1,:));%initialise the bins
%spikes
binned_spikes = zeros(numel(all_spikes(:,1)),numel(bins));
for neuron_id = 1:numel(all_spikes(:,1))
    for idx_bins = 1:1:numel(bins)-1
        binned_spikes(neuron_id,idx_bins) = sum(all_spikes(neuron_id,bins(idx_bins):(bins(idx_bins + 1) - 1) ),2);
    end
    neuron_id
end

%coefficients
binned_coefficient = zeros(numel(all_coeffs(1,:)),numel(bins));
for i_coeff = 1:numel(all_coeffs(1,:))
    for idx_bins = 1:1:numel(bins)-1
        binned_coefficient(i_coeff,idx_bins) = mean(all_coeffs(bins(idx_bins):(bins(idx_bins + 1) - 1), i_coeff ));
    end
end
end