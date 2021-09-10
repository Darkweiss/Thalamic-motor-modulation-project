chronic = {'093 3_2021-07-07-133626-0000DLC_resnet50_More landmarks chronic testSep6shuffle1_1030000.csv','384 3_2021-07-07-133640-0000DLC_resnet50_More landmarks chronic testSep6shuffle1_1030000.csv','385 3_2021-07-07-133631-0000DLC_resnet50_More landmarks chronic testSep6shuffle1_1030000.csv','683 3_2021-07-07-133635-0000DLC_resnet50_More landmarks chronic testSep6shuffle1_1030000.csv','907 3_2021-07-07-133622-0000DLC_resnet50_More landmarks chronic testSep6shuffle1_1030000.csv'};
coordinates_3D = triangulate_DLC(chronic);
coordinates_3D_squeezed = reshape(coordinates_3D,[24,5400])'; %% the data is now X coordinates of all landmarks, then Y then Z
n_clusters=10;
[idx_all,C] = kmeans(coordinates_3D_squeezed,n_clusters);
idx=idx_all(~isnan(idx_all));
Y =tsne(coordinates_3D_squeezed);
gscatter(Y(:,1),Y(:,2),idx)