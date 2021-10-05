%%calculate variables
%% centroid:
centroid.x = nanmean(poses(:,1,:));
centroid.y = nanmean(poses(:,2,:));
centroid.z = nanmean(poses(:,3,:));
%% movement
movement =zeros(numel(poses(1,1,:)),1);
for n = 1:numel(poses(1,1,:))-1
    movement(n+1) = norm([centroid.x(1,1,n),centroid.y(1,1,n),centroid.z(1,1,n)]-[centroid.x(1,1,n+1),centroid.y(1,1,n+1),centroid.z(1,1,n+1)]);
    movement = abs(movement);
end
%% correlation
for neuron=1:numel(synced_spikes(:,1))
    correlation_matrix = corrcoef(movement,synced_spikes(neuron,:));
    correlations(neuron)= correlation_matrix(1,2);
end
correlations = abs(correlations);
[original, neuron_idx] = sort(correlations,'descend');
%% centroid movement
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
            %sound(y,Fs*2)
        end
    end
    pause(0.03)
    clf;   
end

%% grid cells?
for neuron_id = 285
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
end
end

