%%% this function will take the coefficients describing the mouse posture
%%% and produce tuning curves for each neuron
%%% coefficients are: centroid location x, y, z, yaw, roll, pitch, PC 1, 2,
%%% 3
trials = 6;
all_spikes = [];
all_coeffs = [];
for trial = 1:trials
    all_spikes = cat(2,all_spikes,synced_spikes{trial});
    all_coeffs = cat(1,all_coeffs,coeffs{trial});
end

metric = 6;
metric_mean = mean(all_coeffs(:,metric));
metric_std = std(all_coeffs(:,metric));
metric_sem = metric_std/(length(all_coeffs(:,metric)));
bin_edges = -270:10:270;
%bin_edges = -4:0.5:4;
spike_sum = 0;
neuron = zeros(numel(synced_spikes{1}(:,1)),numel(bin_edges)-1);
for neuron_id = 1:numel(synced_spikes{1}(:,1))
    for i_bins =1:numel(bin_edges)-1
        for i_frame = 1:numel(all_spikes(1,:))
            if  bin_edges(i_bins) <= all_coeffs(i_frame,metric) && all_coeffs(i_frame,metric) <= bin_edges(i_bins+1)
                spike_sum = spike_sum + all_spikes(neuron_id,i_frame);
            end %end if for bins
        end %end frame loop
        neuron(neuron_id,i_bins) = spike_sum;
        spike_sum = 0;
    end %end bin loop
end %end neuron loop
normalised = normr(neuron); %normalise

figure
histogram(all_coeffs(:,metric))
xlim([-3 3])
%% plotting
figure
edges = bin_edges(2:end) - (bin_edges(2)-bin_edges(1))/2;
for i=1:numel(rown)
%figure
plot(edges,(neuron(rown(i),:)))
%plot(edges,normalised(rown(i),:))
hold on
end


%% big spikes

metric = 6;
metric_mean = mean(all_coeffs(:,metric));
metric_std = std(all_coeffs(:,metric));
metric_sem = metric_std/(length(all_coeffs(:,metric)));
bin_edges = -270:10:270;
%bin_edges = -4:0.5:4;
spike_sum = 0;
neuron = zeros(numel(big_spikes(:,1)),numel(bin_edges)-1);
for neuron_id = 1:numel(big_spikes(:,1))
    for i_bins =1:numel(bin_edges)-1
        for i_frame = 1:numel(all_spikes(1,:))
            if  bin_edges(i_bins) <= all_coeffs(i_frame,metric) && all_coeffs(i_frame,metric) <= bin_edges(i_bins+1)
                spike_sum = spike_sum + all_spikes(rown(neuron_id),i_frame);
            end %end if for bins
        end %end frame loop
        neuron(neuron_id,i_bins) = spike_sum;
        spike_sum = 0;
    end %end bin loop
end %end neuron loop
normalised = normr(neuron); %normalise

%% plotting
figure
edges = bin_edges(2:end) - (bin_edges(2)-bin_edges(1))/2;
for i=1:numel(neuron(:,1))
%figure
%plot(edges,(neuron(i,:)))
plot(edges,normalised(i,:))
hold on
end

