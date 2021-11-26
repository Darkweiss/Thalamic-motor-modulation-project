function[tuning] = tuning_by_time(x,y,pmtrs,n_shifts,plotting)
%%% This function takes as input a coefficient (x), single neuron spikes
%%% (y), parameters (same as in tuning_curve_bayes), and the number of
%%% shifts
N = numel(x);
if numel(y)~=N
    error('x and y must be same size')
end

xmin = prctile(x,pmtrs.prctilelo);
xmax = prctile(x,pmtrs.prctilehi);

xedges = linspace(xmin,xmax,pmtrs.Nbins);
xbc = 0.5*xedges(1:end-1)+0.5*xedges(2:end);

[Hxvalues, ~,bin] = histcounts(x,xedges);
%% real tuning curve
spike_n = zeros(numel(Hxvalues),1)'; % initialise the vector to store spikes
%get the number of spikes in each bin
for i=1:numel(Hxvalues)
    idx = find(bin==i);
    spike_n(i) = sum(y(idx));
end
tuning = spike_n./Hxvalues;%divide spikes by number of time

%% shuffles
%get random time shift intigers between ~20s after start of trial and 20s before end
if plotting
    shuffle_times = randi([70 (numel(x(1,:))- 70)],1, n_shifts);
    shuffle_matrix = zeros(n_shifts,numel(Hxvalues)); %initialise the matrix to store data
    clear Hxvalues bin

    for n = 1:n_shifts
        [shifted_coeffs,aligned_spikes] = shift_time(x,y,shuffle_times(n));
        [Hxvalues, ~,bin] = histcounts(shifted_coeffs,xedges);
        for i=1:numel(Hxvalues)
            idx = find(bin==i);
            shuffle_matrix(n,i) = sum(aligned_spikes(idx));
        end
        shuffle_matrix(n,:) = shuffle_matrix(n,:)./Hxvalues;%divide spikes by number of time
    end

    %get mean of the bins
    mean_matrix = nanmean(shuffle_matrix,1);
end
%% plotting
if plotting
    figure
    hold on
    subplot(1,2,1)
    plot(xbc, tuning)
    ylim([0 max(tuning) + 1])
    subplot(1,2,2)
    plot(xbc, mean_matrix)
    ylim([0 max(tuning) + 1])
end
%% 
function[shifted_coeffs,aligned_spikes] = shift_time(binned_coeffs,binned_spikes,n_bins)
    binned_coeffs(:,1:n_bins) = [];
    binned_spikes(:,(end - n_bins + 1):end) = [];
    shifted_coeffs = binned_coeffs;
    aligned_spikes = binned_spikes;
end

end