function[] = position_tuning(x,y,spikes, bins,neuron)
%%% x = X coordinates, y = Y coordinates, spikes = spikes for neuron
N = numel(x);
if numel(spikes)~=N
    error('x and spikes must be same size')
end

lo = 0;
high = 100;
xmin = prctile(x,lo);
xmax = prctile(x,high);

ymin = prctile(y,lo);
ymax = prctile(y,high);

xedges = linspace(xmin,xmax,bins);
yedges = linspace(xmin,xmax,bins);

data(:,1) = x;
data(:,2) = y;

xbc = 0.5*xedges(1:end-1)+0.5*xedges(2:end);
[N,Xedges,Yedges,binX,binY] = histcounts2(x,y,xedges,yedges);
%% real tuning curve
spike_n = zeros(numel(N(1,:))); % initialise the vector to store spikes
%get the number of spikes in each bin
for i=1:numel(N(1,:))
    for j=1:numel(N(1,:))
        idx_x = find(binX==i);
        idx_y = find(binY==j);
        idx = (binX==i & binY==j);
        spike_n(i,j) = sum(spikes(idx));
    end
end
tuning = spike_n./N;%divide spikes by number of time

figure
pcolor(tuning)
title(num2str(neuron))
end