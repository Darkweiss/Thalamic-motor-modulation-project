trial_n = 3;
poses = final_landmarks{trial_n};
%% get x y z centroid locations
centroid.x = nanmean(poses(:,1,:));
centroid.y = nanmean(poses(:,2,:));
centroid.z = nanmean(poses(:,3,:));
figure
hold on
count=1;

pts = linspace(-30,30,25);

N = histcounts2(centroid.y(1,1,:), centroid.x(1,1,:), pts, pts);
% Plot scattered data (for comparison):
subplot(1, 2, 1);
scatter(centroid.x(1,1,:), centroid.y(1,1,:), 'r.');
axis equal;
set(gca, 'XLim', pts([1 end]), 'YLim', pts([1 end]));

% Plot heatmap:
subplot(1, 2, 2);
imagesc(pts, pts, N);
axis equal;
set(gca, 'XLim', pts([1 end]), 'YLim', pts([1 end]), 'YDir', 'normal');
