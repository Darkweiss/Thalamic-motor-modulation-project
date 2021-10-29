%% analyse coefficients

function[normalised] = analyse_coefficients(coefficient_n,coefficients, spikes, selected_neurons,areas)

coefficient_strings = {'Centroid X','Centroid Y','Centroid Z','Yaw angle','Roll angle','Pitch angle','PC 1','PC2','PC3','Locomotion'};

if coefficient_n > 0 && coefficient_n < 3
    bin_edges = -25:1:25;
elseif coefficient_n == 3;
    bin_edges = 0:0.5:9;
elseif coefficient_n == 4;
    bin_edges = -270:10:270;
elseif coefficient_n == 5 || coefficient_n == 6;
    bin_edges = -90:10:90;
elseif coefficient_n >= 7 && coefficient_n < 10;
    bin_edges = -4:0.5:4;
else
    bin_edges = 0:0.1:1.2;
end
spike_sum = 0;
neuron = zeros(numel(spikes(:,1)),numel(bin_edges)-1);
for neuron_id = 1:numel(spikes(:,1))
    for i_bins = 1:numel(bin_edges)-1
        for i_frame = 1:numel(spikes(1,:))
            if  bin_edges(i_bins) <= coefficients(coefficient_n,i_frame) && coefficients(coefficient_n,i_frame) <= bin_edges(i_bins+1)
                spike_sum = spike_sum + spikes(neuron_id,i_frame);
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
for i=1:numel(selected_neurons)
%figure
%plot(edges,(neuron(i,:)))

hold on
if strcmp(areas{i}, 'Zona incerta');
    plot(edges,normalised(selected_neurons(i),:),'r')
elseif strcmp(areas{i}, 'VPM');
    plot(edges,normalised(selected_neurons(i),:),'b')
elseif strcmp(areas{i}, 'PO');
    plot(edges,normalised(selected_neurons(i),:),'g')
elseif strcmp(areas{i}, 'Hippocampus');
    plot(edges,normalised(selected_neurons(i),:),'k')
else
    %plot(edges,normalised(selected_neurons(i),:),'c')
end
end

xlabel(coefficient_strings{coefficient_n});
ylabel('Normalised firing rate');

end