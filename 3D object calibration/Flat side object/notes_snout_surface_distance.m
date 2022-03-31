% AIM: in Luka's data of Nov 2021. identify the surface of an object from
% landmarks and, using mouse landmarks, thereby calculate Snout-Surface
% Distance, and relate SSD to spikes
%
% RSP Jan 2022

file = 'C:\Users\mjcssrp\Dropbox (The University of Manchester)\170320\lab and lab meetings\motor state project\luka object landmarks nov2021-jan2022\Data for Rasmus\Rasmus_data.mat';

load(file,'coordinates','final_landmarks','synced_spikes')

Pfile = 'C:\Users\mjcssrp\Dropbox (The University of Manchester)\170320\lab and lab meetings\motor state project\luka object landmarks nov2021-jan2022\Data for Rasmus\Pcal_rp';
load(Pfile,'P')

video = 'C:\DeepLabCut\Luka\Mouse 8 Day 1 object_1-Luka-2022-03-29\videos\camera_3_trial_6_2021-12-06-150725-0000.avi';

%%
vh = VideoReader(video);
im = readFrame(vh);

coordinates = coordinates_all{5};
Ncoord = size(coordinates,1);

for i = 1:4
figure
subplot 121
imshow(im), hold on
coords2 = P{i}*[coordinates';ones(1,Ncoord)];
coords2 = coords2(1:2,:)./(ones(2,1)*coords2(3,:));
plot(coords2(1,:),coords2(2,:),'ro')
title(i)

subplot 122
imshow(im), hold on
coords2 = P{i}*[coordinates';ones(1,Ncoord)];
coords2 = coords2(1:2,:)./(ones(2,1)*coords2(3,:));
plot(coords2(2,:),coords2(1,:),'ro')
title(i)
end