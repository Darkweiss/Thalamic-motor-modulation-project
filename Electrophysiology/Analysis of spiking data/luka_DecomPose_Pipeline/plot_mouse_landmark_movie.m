function plot_mouse_landmark_movie(x,linestyle,step)

figure('units','normalized','outerposition',[0 0.05 1 .95])
tmp = x(:,1,:);
xmin = min(tmp(:))-1;
xmax = max(tmp(:))+1;
tmp = x(:,2,:);
ymin = min(tmp(:))-1;
ymax = max(tmp(:))+1;
tmp = x(:,3,:);
zmin = min(tmp(:))-1;
zmax = max(tmp(:))+1;
clear tmp

for i = 1:step:size(x,3)
    pose = x(:,:,i);
    subplot(2,2,1), cla
    plot_mouse_landmarks(pose(:,[1 2]),linestyle,true)
    xlabel('x'),ylabel('y')
    axis equal
    axis([xmin xmax ymin ymax])
    subplot(2,2,2), cla
    plot_mouse_landmarks(pose(:,[1 3]),linestyle,true)
    xlabel('x'),ylabel('z')
    axis equal
    axis([xmin xmax zmin zmax])
    subplot(2,2,3), cla
    plot_mouse_landmarks(pose(:,[2 3]),linestyle,true)
    xlabel('y'),ylabel('z')
    axis equal
    axis([ymin ymax zmin zmax])
    subplot(2,2,4), cla
    plot_mouse_landmarks(pose,linestyle,true)
    xlabel('x'),ylabel('y'),zlabel('z')
    axis equal
    axis([xmin xmax ymin ymax zmin zmax])
    
    pause(.01)
end

