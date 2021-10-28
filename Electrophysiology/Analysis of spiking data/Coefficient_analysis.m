%%% this function will take the coefficients describing the mouse posture
%%% and produce tuning curves for each neuron
%%% coefficients are: centroid location x, y, z, yaw, roll, pitch, PC 1, 2,
%%% 3
coefficient_strings = {'Centroid X','Centroid Y','Centroid Z','Yaw angle','Roll angle','Pitch angle','PC 1','PC2','PC3','speed'};

trials = 7;
all_spikes = [];
all_coeffs = [];
for trial = 1:trials
    all_spikes = cat(2,all_spikes,synced_spikes{trial});
    all_coeffs = cat(1,all_coeffs,coeffs{trial});
end

metric = 3;
metric_mean = mean(all_coeffs(:,metric));
metric_std = std(all_coeffs(:,metric));
metric_sem = metric_std/(length(all_coeffs(:,metric)));
bin_edges = -270:10:270;
%bin_edges = -4:0.5:4;
%bin_edges = 0:0.1:1.2;
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
xlim([-270 270])
%% plotting
figure
edges = bin_edges(2:end) - (bin_edges(2)-bin_edges(1))/2;
for i=5
%figure
plot(edges,(neuron(analysis_id(i),:)))
%plot(edges,normalised(analysis_id(i),:))
hold on
end


%% bigger bins
metric = 3;

metric_mean = mean(all_coeffs(:,metric));
metric_std = std(all_coeffs(:,metric));
metric_sem = metric_std/(length(all_coeffs(:,metric)));
bin_edges = 2:0.5:9;
%bin_edges = -270:10:270; %angle edges
%bin_edges = -4:0.5:4; %PCA edges
%bin_edges = 0:0.1:1.2; %locomotion edgees
spike_sum = 0;
neuron = zeros(numel(binned_spikes(:,1)),numel(bin_edges)-1);
for neuron_id = 1:numel(binned_spikes(:,1))
    for i_bins = 1:numel(bin_edges)-1
        for i_frame = 1:numel(binned_spikes(1,:))
            if  bin_edges(i_bins) <= binned_coefficient(metric,i_frame) && binned_coefficient(metric,i_frame) <= bin_edges(i_bins+1)
                spike_sum = spike_sum + binned_spikes(neuron_id,i_frame);
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
for i=5
%figure
%plot(edges,(neuron(i,:)))

hold on
if strcmp(area{i}, 'Zona incerta');
    plot(edges,normalised(analysis_id(i),:),'r')
elseif strcmp(area{i}, 'VPM');
    plot(edges,normalised(analysis_id(i),:),'b')
elseif strcmp(area{i}, 'PO');
    plot(edges,normalised(analysis_id(i),:),'g')
elseif strcmp(area{i}, 'Hippocampus');
    plot(edges,normalised(analysis_id(i),:),'k')
else
    plot(edges,normalised(analysis_id(i),:),'c')
end
end

xlabel(coefficient_strings{metric});
ylabel('Normalised firing rate');



