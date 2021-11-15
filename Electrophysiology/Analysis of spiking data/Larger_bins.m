%%% prepare the spiking data so that it is in larger bins, includes neurons
%%% with a sufficient number of spikes and includes good neurons only

kilosort_folder = 'C:\Ephys data\Chronic ephys\Chronic_mouse5_383780\Electrophysiology\Day 2\kilosort';
addpath(kilosort_folder);
load rez
spike_threshold = 1000;
bad_idx = find(rez.good==0);

trials = 6;
all_spikes = [];
for trial = 1:trials
    all_spikes = cat(2,all_spikes,synced_spikes{trial});
end

all_coeffs = [];
for trial = 1:trials
    all_spikes = cat(2,all_spikes,synced_spikes{trial});
    all_coeffs = cat(1,all_coeffs,coeffs{trial});
end


all_spikes(bad_idx,:) = NaN; %remove the 'bad' neurons
[no_spikes_idx] = find(sum(all_spikes,2)< spike_threshold); %remove neurons with less than 1000 spikes
all_spikes(no_spikes_idx,:) =NaN;

analysis_id = find(~isnan(all_spikes(:,1)));


%% bin into larger bins
%neurons
bins = 1:10:numel(all_spikes(1,:));
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

%% assign a brain area to good neurons
areas = {'Zona incerta','VPM','PO','Hippocampus'};
limits = {[0 200],[201 1200],[1201 1950], [1951 3250]};
colours = 'gbcmyk';
area = repmat({''},numel(analysis_id),1);
counter = 1;
for area_id = 1:numel(limits)
    for neuron_id = 1:numel(analysis_id)
        if templateDepths(analysis_id(neuron_id))> limits{area_id}(1,1) && templateDepths(analysis_id(neuron_id))< limits{area_id}(1,2)
            area{counter} = areas{area_id};
            counter = counter + 1;
        else
            counter = counter + 1;
        end
    end
    counter = 1;
end
