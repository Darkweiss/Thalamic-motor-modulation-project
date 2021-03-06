% Pipeline for Decomposition of 3D pose (triangulation data) into location, angle and shape
% RSP Oct 2021


close all
clear all

%% Here, specific the data (triangulation data and corresponding videos):
%data for one mouse, one trial
% triangulated data for object 1:
% fn is 3D data, object is the object used in the trail and video is the
% video of the trial
final_landmarks_vid{1} = 'C:\Users\mjcssrp\Dropbox (The University of Manchester)\170320\lab and lab meetings\motor state project\video rebecca oct2021\for Rasmus triangulation cones M1\mouse 1_ bottom obj_nor 3\mouse 1_bottom obj_nor 3_triangulated.mat';
object{1} = 'no obj';
for i=1:7
    video{i} = 'C:\Ephys data\Chronic ephys\Chronic_mouse6_383781\bodycams\Day4\Camera_3_trial_1_2021-11-09-141156-0000.avi';
end
%% animate the 3D pose data
step = 1;
plot_mouse_landmark_movie(final_landmarks{3}(:,:,1:100),'-',step)


%% compute the shape PCA using wide sample of data (multiple videos):
Nshape = 3;
[vec,val] = DecomPose_PCA(final_landmarks, Nshape);
vec = vec(:,end:-1:end-Nshape+1);

%% for a selected video, decompose the 3D in each frame into coefficients of
% rigid motion (location, angle) and shape:
clear coeffs
for i = 1:6
    [coeffs{i}, nans{i}] = DecomPose(final_landmarks{i},video{i},vec,false,false);
    i
end
clear i

for i = 1:7
    synced_spikes{i}(:,nans{i}) = [];
end
%% Analyse the distribution of the coefficients:
close all
for i = 1:7
    DecomPose_Analysis(coeffs{i})
end

