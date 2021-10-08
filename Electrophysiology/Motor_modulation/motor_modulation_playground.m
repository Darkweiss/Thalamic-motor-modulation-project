%%calculate variables
%% get x y z centroid locations
centroid.x = nanmean(poses(:,1,:));
centroid.y = nanmean(poses(:,2,:));
centroid.z = nanmean(poses(:,3,:));
%% movement
movement =zeros(numel(poses(1,1,:)),1);
for n = 1:numel(poses(1,1,:))-1
    movement(n+1) = norm([centroid.x(1,1,n),centroid.y(1,1,n)]-[centroid.x(1,1,n+1),centroid.y(1,1,n+1)]);
    movement = abs(movement);
end
%% correlation
for neuron=1:numel(synced_spikes(:,1))
    correlation_matrix = corrcoef(movement,synced_spikes(neuron,:));
    correlations(neuron)= correlation_matrix(1,2);
end
correlations = abs(correlations);
[original, neuron_idx] = sort(correlations,'descend');
neuron_idx(58:68);%%neurons that spike most with movement
%% centroid movement
neuron_id= 343;
for n=1:1000    
    for i = 1:Np
        plot3(centroid.x(1,1,n),centroid.y(1,1,n),centroid.z(1,1,n),'.','MarkerSize',20,'Color','k');
        hold on
    end
    xlabel('X'); ylabel('Y'); zlabel('Z');
    title(num2str(n))
    view([180 90])
    xlim([-30 30]); ylim([-30 30]); zlim([-5 40]);
    if synced_spikes(neuron_id,n) > 0
        for i = 1:numel(synced_spikes(neuron_id,n))
            h1 = plot(20,20,'.', 'MarkerSize',40,'Color','r');
            %playblocking(player);
            sound(y,Fs*2)
        end
    end
    pause(0.03)
    clf;   
end
for i=neuron_idx(58:68)
    figure
    hold on
    coefficient = movement'.*synced_spikes(i,:);
    histogram(coefficient)
    title(num2str(i))
end
figure
histogram(movement)
scatter(movement,synced_spikes(neuron_id,:))
%% grid cells?
for neuron_id = neuron_idx(58:100)
clear x y
figure
hold on
count=1;
for n=1:numel(poses(1,1,:))   
    if synced_spikes(neuron_id,n) > 0
        for i = 1:numel(synced_spikes(neuron_id,n))
            x(count)= centroid.x(1,1,n);
            y(count)= centroid.y(1,1,n);
            count=count+1;
            %h1 = plot(,centroid.y(1,1,n),'.', 'MarkerSize',20,'Color','r');            
            %playblocking(player);
            %sound(y,Fs*2)
        end
    end
%     xlabel('X'); ylabel('Y'); zlabel('Z');
%     title(num2str(n))
%     view([180 90])
%     xlim([-30 30]); ylim([-30 30]); zlim([-5 40]);
end
pts = linspace(-30,30,25);
if exist('x')
    N = histcounts2(y(:), x(:), pts, pts);
    % Plot scattered data (for comparison):
    subplot(1, 2, 1);
    scatter(x, y, 'r.');
    axis equal;
    set(gca, 'XLim', pts([1 end]), 'YLim', pts([1 end]));
    
    % Plot heatmap:
    subplot(1, 2, 2);
    imagesc(pts, pts, N);
    axis equal;
    set(gca, 'XLim', pts([1 end]), 'YLim', pts([1 end]), 'YDir', 'normal');
    title(num2str(neuron_id))
end
end
%% rearing cells?
for neuron=1:numel(synced_spikes(:,1))
    correlation_matrix = corrcoef(centroid.z(1,1,:),synced_spikes(neuron,:));
    correlations(neuron)= correlation_matrix(1,2);
end
correlations = abs(correlations);
[original, neuron_idx] = sort(correlations,'descend');
plot_neurons = neuron_idx(58:end);%%neurons that spike most with z movement

neuron = 2; %%select a neuron

figure
hold on
plot(squeeze(centroid.z(1,1,:)))
plot(synced_spikes(plot_neurons(neuron),:),'color','k')
title(num2str(plot_neurons(neuron)))

sd= std(squeeze(centroid.z(1,1,:)));
avg = mean(squeeze(centroid.z(1,1,:)));
%frames where z is 2SD above mean
count_1 = 1;
count_2 = 1;
for frame = 1: numel(synced_spikes(1,:))
    if squeeze(centroid.z(1,1,frame))> avg + sd
        rearing_spikes(count_1) = synced_spikes(neuron,frame);
        count_1 = count_1 + 1;
    else
        non_rearing_spikes(count_2) = synced_spikes(neuron,frame);
        count_2 = count_2 + 1;
    end
end

mean_rearing = mean(rearing_spikes)
mean_non_rearing = mean(non_rearing_spikes)