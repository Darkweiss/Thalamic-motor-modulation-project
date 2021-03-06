chronic = {'093 3_2021-07-07-133626-0000DLC_resnet50_More landmarks chronic testSep6shuffle1_1030000.csv','384 3_2021-07-07-133640-0000DLC_resnet50_More landmarks chronic testSep6shuffle1_1030000.csv','385 3_2021-07-07-133631-0000DLC_resnet50_More landmarks chronic testSep6shuffle1_1030000.csv','683 3_2021-07-07-133635-0000DLC_resnet50_More landmarks chronic testSep6shuffle1_1030000.csv','907 3_2021-07-07-133622-0000DLC_resnet50_More landmarks chronic testSep6shuffle1_1030000.csv'};
coordinates_3D = triangulate_DLC(chronic);

%delete poses with NaNs
coordinates_3D_squeezed = reshape(coordinates_3D,[24,5400])'; %% the data is now X coordinates of all landmarks, then Y then Z
[rows, columns] = find(isnan(coordinates_3D_squeezed));
coordinates_3D(:,:,unique(rows))=[];

poses = coordinates_3D;
N=length(poses(1,1,:));

X = [0 3.5 0; -1 2 0; 1 2 0; 0 3 0;0 1.5 0;0 1 0; 0 -1.5 0; 0 -3.5 0];
for n = 1:N
    Y = squeeze(poses(:,1:3,n)); 
    [~, ~, t] = procrustes(X, Y, 'Scaling', false,'Reflection',false);
    poses(:,1:3,n) = t.b*Y * t.T + t.c;
end

%kmeans and t-sne
coordinates_3D_squeezed = reshape(poses,[24,N])'; %% the data is now X coordinates of all landmarks, then Y then Z
n_clusters=8;
[idx,C] = kmeans(coordinates_3D_squeezed,n_clusters);
Y =tsne(coordinates_3D_squeezed);
figure
gscatter(Y(:,1),Y(:,2),idx)

%% plot the clusters
%get means for all clusters
for i=1:n_clusters
    %get indicies
    idx_clusters = find(idx==i);
    for i_landmarks=1:8
        for i_dim = 1:3
        cluster_means{i}(i_landmarks,i_dim)=mean(poses(i_landmarks,i_dim,idx_clusters));
        end
    end
end
%actual plotting
cval = 'rbbccgmy';
figure
for i=1:n_clusters
    for i_landmarks=1:8
        subplot(5,2,i)
        plot3(cluster_means{i}(i_landmarks,1),cluster_means{i}(i_landmarks,2),cluster_means{i}(i_landmarks,3),'.','MarkerSize',20,'Color',cval(i_landmarks))
        hold on
        xlim([-10 10]); ylim([-10 10]); zlim([-3 5]);  
        view([90 0])
    end
end