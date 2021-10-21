function[] = Place_cells(trial_n, selected_neurons, final_landmarks, synced_spikes)
% this function plots the centroid location of the mouse at the time of
% spiking as a heatmap and raw data
poses = final_landmarks{trial_n};
%% get x y z centroid locations
centroid.x = nanmean(poses(:,1,:));
centroid.y = nanmean(poses(:,2,:));
centroid.z = nanmean(poses(:,3,:));

%% go over selected neurons and plot heatmaps
for neuron_id = selected_neurons
    clear x y
    figure
    hold on
    count=1;
    for n=1:numel(poses(1,1,:))
        if synced_spikes{trial_n}(neuron_id,n) > 0
            for i = 1:numel(synced_spikes{trial_n}(neuron_id,n))
                x(count)= centroid.x(1,1,n);
                y(count)= centroid.y(1,1,n);
                count=count+1;
                %h1 = plot(,centroid.y(1,1,n),'.', 'MarkerSize',20,'Color','r');
                %playblocking(player);
                %sound(y,Fs*2)
            end
        end
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
end %end function