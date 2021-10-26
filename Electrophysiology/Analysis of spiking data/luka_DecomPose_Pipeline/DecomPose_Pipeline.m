% Pipeline for Decomposition of 3D pose (triangulation data) into location, angle and shape
% RSP Oct 2021


close all
clear all

%% Here, specific the data (triangulation data and corresponding videos):
%data for one mouse, one trial
% triangulated data for object 1:
fn{1} = 'C:\Users\mjcssrp\Dropbox (The University of Manchester)\170320\lab and lab meetings\motor state project\video rebecca oct2021\for Rasmus triangulation cones M1\mouse 1_ bottom obj_nor 3\mouse 1_bottom obj_nor 3_triangulated.mat';
object{1} = 'bottom obj';
video{1} = 'C:\Users\mjcssrp\Dropbox (The University of Manchester)\170320\lab and lab meetings\motor state project\video rebecca oct2021\for Rasmus triangulation cones M1\mouse 1_ bottom obj_nor 3\383784 385 nor 3_2021-09-15.mp4';
% triangulated data for object 2:
fn{2} = 'C:\Users\mjcssrp\Dropbox (The University of Manchester)\170320\lab and lab meetings\motor state project\video rebecca oct2021\for Rasmus triangulation cones M1\mouse 1_ref obj_nor 3\mouse 1_ref obj_nor 3_triangulated.mat';
object{2} = 'ref obj';
video{2} = '383784 093 nor 3_2021-09-13.mp4';
% triangulated data for object 3:
fn{3} = 'C:\Users\mjcssrp\Dropbox (The University of Manchester)\170320\lab and lab meetings\motor state project\video rebecca oct2021\for Rasmus triangulation cones M1\mouse 1_top obj_nor 3\mouse 1_top obj_nor 3_triangulated.mat';
object{3} = 'top obj';
video{3} = '383784 093 nor 3_2021-09-14.mp4';

%% animate the 3D pose data
load(fnout{1},'x')
step = 1;
plot_mouse_landmark_movie(x(:,:,1:100),'-',step)


%% compute the shape PCA using wide sample of data (multiple videos):
Nshape = 3;
[vec,val] = DecomPose_PCA(fnout, Nshape);
vec = vec(:,end:-1:end-Nshape+1);

%% for a selected video, decompose the 3D in each frame into coefficients of
% rigid motion (location, angle) and shape:
clear coeffs
for i = 1:3
    coeffs{i} = DecomPose(fn{i},video{i},vec,.1,false);
end
clear i

%% Analyse the distribution of the coefficients:
close all
for i = 1:3
    DecomPose_Analysis(coeffs{i})
end

%% compute the shape change PCA using wide sample of data (multiple videos):
Nshape = 3;
[vec,val] = DecomPoseChange_PCA(fnout, 3);
vec = vec(:,end:-1:end-Nshape+1);

%% generate simulation data for testing
clear fnout
fnout{1} = 'test';
load(fn{1},'x');
refpose = x(:,:,1)-ones(6,1)*mean(x(:,:,1));
figure
plot_mouse_landmarks(refpose(:,1:2),'-',true)
% % pure translation
% xn(:,:,1) = refpose;
% for i = 2:size(x,3)
%     tv = .5*(rand(1,3)-.5);
%     xn(:,:,i) = xn(:,:,i-1)+ones(6,1)*tv;
% end
% translation and rotation
% xn(:,:,1) = refpose;
% for i = 2:size(x,3)
%     thetas = (rand(1,3)-[.5 .5 .5]).*[2*pi 2*pi pi]/(4*pi);
%     rmat = rotate3deuler(thetas,'xyz');
%     tv = .5*(rand(1,3)-.5);
%     xn(:,:,i) = (xn(:,:,i-1)-ones(6,1)*mean(xn(:,:,i-1)))*rmat'+ones(6,1)*tv;
% end
% translation, rotation and shape change
xn(:,:,1) = refpose;
for i = 2:size(x,3)
    thetas = (rand(1,3)-[.5 .5 .5]).*[2*pi 2*pi pi]/(4*pi);
    rmat = rotate3deuler(thetas,'xyz');
    tv = .5*(rand(1,3)-.5);
    dx = [1*(rand(1,3)-.5);zeros(5,3)]; % "Pinocchio mouse"
    xn(:,:,i) = (xn(:,:,i-1)-ones(6,1)*mean(xn(:,:,i-1)))*rmat' + ones(6,1)*tv + dx;
end

x = xn;
clear i r xn
save(fnout{1},'x')