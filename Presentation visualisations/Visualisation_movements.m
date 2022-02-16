%take the first pose
f_pose = final_landmarks(:,:,180);
n_frames = 100;
%create a matrix to hold the movements
poses = zeros(size(final_landmarks(:,:,1:n_frames)));
poses(:,:,1) = f_pose;
%% movement in X
name = 'X_movement.avi';
for i=2:numel(1:n_frames/2)
    temp = poses(:,:,i-1);
    temp(:,1,1) = temp(:,1,1) + 0.2;
    poses(:,:,i) = temp;
end

for i=(n_frames/2)+1:n_frames
    temp = poses(:,:,i-1);
    temp(:,1,1) = temp(:,1,1) - 0.2;
    poses(:,:,i) = temp;
end
%% movement in y
name = 'Y_movement.avi';
for i=2:numel(1:n_frames/2)
    temp = poses(:,:,i-1);
    temp(:,2,1) = temp(:,2,1) + 0.2;
    poses(:,:,i) = temp;
end

for i=(n_frames/2)+1:n_frames
    temp = poses(:,:,i-1);
    temp(:,2,1) = temp(:,2,1) - 0.2;
    poses(:,:,i) = temp;
end


%% movement in z
name = 'Z_movement.avi';
for i=2:numel(1:n_frames/2)
    temp = poses(:,:,i-1);
    temp(:,3,1) = temp(:,3,1) + 0.1;
    poses(:,:,i) = temp;
end

for i=(n_frames/2)+1:n_frames
    temp = poses(:,:,i-1);
    temp(:,3,1) = temp(:,3,1) - 0.1;
    poses(:,:,i) = temp;
end

%% rotation around x
name = 'X_rotation.avi';
theta = 0;
for i=2:numel(1:n_frames/2)
    temp = poses(:,:,1);
    temp(:,2,1) = temp(:,2,1)*cos(theta) - temp(:,3,1)*sin(theta);
    temp(:,3,1) = temp(:,2,1)*sin(theta) + temp(:,3,1)*cos(theta);
    %temp(:,3,1) = temp(:,3,1) + 0.1;
    poses(:,:,i) = temp;
    theta = theta + 0.01;
end

for i=(n_frames/2)+1:n_frames
    temp = poses(:,:,1);
    %temp(:,3,1) = temp(:,3,1) - 0.1;
    temp(:,2,1) = temp(:,2,1)*cos(theta) - temp(:,3,1)*sin(theta);
    temp(:,3,1) = temp(:,2,1)*sin(theta) + temp(:,3,1)*cos(theta);
    poses(:,:,i) = temp;
    theta = theta - 0.01;
end

%% rotation around y
name = 'Y_rotation.avi';
theta = 0;
for i=2:numel(1:n_frames/2)
    temp = poses(:,:,1);
    temp(:,1,1) = temp(:,1,1)*cos(theta) + temp(:,3,1)*sin(theta);
    temp(:,3,1) = temp(:,3,1)*cos(theta) - temp(:,1,1)*sin(theta);
    poses(:,:,i) = temp;
    theta = theta + 0.01;
end

for i=(n_frames/2)+1:n_frames
    temp = poses(:,:,1);
    temp(:,1,1) = temp(:,1,1)*cos(theta) + temp(:,3,1)*sin(theta);
    temp(:,3,1) = temp(:,3,1)*cos(theta) - temp(:,1,1)*sin(theta);
    poses(:,:,i) = temp;
    theta = theta - 0.01;
end

%% rotation around z
name = 'Z_rotation.avi';
theta = 0;
for i=2:numel(1:n_frames/2)
    temp = poses(:,:,1);
    temp(:,1,1) = temp(:,1,1)*cos(theta) - temp(:,2,1)*sin(theta);
    temp(:,2,1) = temp(:,1,1)*sin(theta) + temp(:,2,1)*cos(theta);
    poses(:,:,i) = temp;
    theta = theta + 0.01;
end

for i=(n_frames/2)+1:n_frames
    temp = poses(:,:,1);
    temp(:,1,1) = temp(:,1,1)*cos(theta) - temp(:,2,1)*sin(theta);
    temp(:,2,1) = temp(:,1,1)*sin(theta) + temp(:,2,1)*cos(theta);
    poses(:,:,i) = temp;
    theta = theta - 0.01;
end

%% PCA
[vec,val] = DecomPose_PCA({final_landmarks}, true);
%%Procrustes
refpose = poses(:,:,1);
refpose = refpose - ones(numel(poses(:,1,1)),1)*mean(refpose);
posepro = zeros(size(poses));
posedt = zeros(size(poses));
centroid = zeros(numel(poses(1,1,:)),3);
for i = 1:numel(poses(1,1,:))
    pose = poses(:,:,i);
    centroid(i,:) = mean(pose);
    posedt(:,:,i) = pose - ones(numel(poses(:,1,1)),1)*centroid(i,:);
    [d(i),tmp,~] = procrustes(refpose,pose,'Scaling',false,'Reflection',false);
    posepro(:,:,i) = tmp;
end
mtx = mean(posepro,3);
mtx = mtx - ones(Nlandmarks,1)*mean(mtx,1);
clear i pose tmp
%% PC1
PC = 1;
theta = 2;
name = 'PC1.avi';
for i=2:numel(1:n_frames/2)
    temp =refpose;
    temp = reshape(temp,[27 1]);
    temp = temp .* (vec(:,PC)*theta);
    poses(:,:,i) = reshape(temp,[9 3]);
    theta = theta + 0.01;
end

for i=(n_frames/2)+1:n_frames
    temp = refpose;
    temp = reshape(temp,[27 1]);
    temp = temp .* (vec(PC)*theta);
    poses(:,:,i) = reshape(temp,[9 3]);
    theta = theta - 0.01;
end
%% plotting
mouse_plotting(poses,vid_path,name);
