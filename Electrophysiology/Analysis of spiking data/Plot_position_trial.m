
function[] = Plot_position_trial(trial_n,poses,path)
%% get x y z centroid locations
centroid.x = nanmean(poses{trial_n}(:,1,:));
centroid.y = nanmean(poses{trial_n}(:,2,:));
centroid.z = nanmean(poses{trial_n}(:,3,:));

hold on
pts = linspace(-30,30,25);
f = figure;
N = histcounts2(centroid.y(1,1,:), centroid.x(1,1,:), pts, pts);
% Plot scattered data (for comparison):
subplot(1, 2, 1);
scatter(centroid.x(1,1,:), centroid.y(1,1,:), 'r.');
axis equal;
set(gca, 'XLim', pts([1 end]), 'YLim', pts([1 end]));
title(['Trial ' num2str(trial_n)])

% Plot heatmap:
subplot(1, 2, 2);
imagesc(pts, pts, N);
axis equal;
set(gca, 'XLim', pts([1 end]), 'YLim', pts([1 end]), 'YDir', 'normal');
saveas(f, [path '\' 'mouse_position_trial_' num2str(trial_n)], 'jpg')
