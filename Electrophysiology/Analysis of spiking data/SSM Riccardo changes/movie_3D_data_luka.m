function[] = movie_3D_data_luka(Y,do_save)
%movie_3D_data_luka(poses,1);movie_3D_data_luka(poses_refined,1);
N = size(Y,3);
%
if do_save
    vidObj = VideoWriter(['movie_3D_chronic' num2str(int16(abs(randn)*1000)) '.avi']);
    open(vidObj);
end
%
fig = figure; 
set(fig,'Position',[100 100 1000 450]);
for n = 1:2
    h(n) = subplot(1,2,n);
end
which_frames = 1:N;
for n = which_frames(1):3:which_frames(end)
    %
    drawnow;
    %
    cla(h(1));
    plot3D_chronic_pose(Y(:,:,n),true,h(1),[-10 10]);
    %
    cla(h(2));
    plot3D_chronic_pose(Y(:,:,n),true,h(2),[0 90]);
    %
    pause(0.025);
    %
    if do_save
       currFrame = getframe(gcf);
       writeVideo(vidObj,currFrame); 
    end
end
if do_save
    close(vidObj);
end

function[] = plot3D_chronic_pose(X,draw_sticks,h,view_val)
cval = [1 0 0; 0 0 1; 0 0 0.5; 0 1 1; 0 0.5 0.5; 0.75 0 0.25; 0.25 0 0.75; 1 0 1; 0 1 0; 1 0.5 0; 1 1 0];
Np = size(X,1);
N = size(X,3);
subplot(h); hold on;
for n = 1:N
    %landmarks
    for m = 1:Np
        plot3(X(m,1,n), X(m,2,n), X(m,3,n),'.','MarkerSize',25,'Color',cval(m,:)); 
    end
    %sticks
    if draw_sticks
        land = [1 2; 2 3; 4 3; 5 3; 6 4; 6 5; 7 6; 8 7];
        Nstick = size(land,1); 
        for m = 1:Nstick
            xl = [X(land(m,1),1) X(land(m,2),1)];
            yl = [X(land(m,1),2) X(land(m,2),2)];
            zl = [X(land(m,1),3) X(land(m,2),3)];
            line(xl, yl, zl,'LineWidth',2,'Color',0.66*ones(1,3));
        end
    end
    xm = nanmean(X(:,1,1)); ym = nanmean(X(:,2,1)); zm = nanmean(X(:,3,1));
    dxm = 10; dym = 10; dzm = 10; 
    xlim([xm-dxm xm+dxm]); ylim([ym-dym ym+dym]); zlim([zm-dzm zm+dzm]);
end
view(view_val);
xlim([-30 30]); ylim([-30 30]); zlim([-5 15]);
drawnow;
