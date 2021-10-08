function[] = movie_SSM_chronic_luka(mean_pose,P,lambda)
%make a movie for change in body shape along directions of the eigenposes
for n = 1:3
    mean_pose(:,n) = mean_pose(:,n)-mean(mean_pose(:,n));
end
Nshape = numel(lambda);
for n = 1:Nshape
    P{n} = P{n}(:);
end
P = horzcat(P{:});
mean_pose = mean_pose(:);
Np = size(mean_pose,1)/3;
do_save = false; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if do_save
    vidObj = VideoWriter('SSM_chronic.avi');
    open(vidObj);
end
Nmovie = 100;
fig = figure; 
set(fig,'Position',[200 200 800 400]);
h(1) = subplot(1,2,1);
h(2) = subplot(1,2,2);
cval = [1 0 0; 0 0 1; 0 0 0.5; 0 1 1; 0 0.5 0.5; 0.75 0 0.25; 0.25 0 0.75; 1 0 1; 0 1 0; 1 0.5 0; 1 1 0];
for nn = 1:Nshape %e.g. first 3 eigenposes
    ind0_image = (nn-1)*Nmovie;
    b_movie = zeros(Nshape,Nmovie);
    b_movie(nn,:) = sqrt(6)*sqrt(lambda(nn))*sin(2*pi*[1:Nmovie]/(50));
    poses_movie = zeros(Np,3,Nmovie);
    for n = 1:Nmovie
        temp = mean_pose + P*b_movie(:,n);
        poses_movie(:,:,n) = reshape(temp,Np,3);
    end
    for n = 1:Nmovie
        %
        subplot(h(1)); hold on;
        title(['Eigenpose: ' num2str(nn)],'FontSize',16);
        for m = 1:Np
            plot3(poses_movie(m,1,n),poses_movie(m,2,n),poses_movie(m,3,n),'.','MarkerSize',18,'Color',cval(m,:));
        end
        %xlim([min(min(poses_movie(:,1,:))) max(max(poses_movie(:,1,:)))]);
        %ylim([min(min(poses_movie(:,2,:))) max(max(poses_movie(:,2,:)))]);
        %zlim([min(min(poses_movie(:,3,:))) max(max(poses_movie(:,3,:)))]);
        xlabel('X','FontSize',16);ylabel('Y','FontSize',16);zlabel('Z','FontSize',16);
        zlim([-10 10]); ylim([-10 10]); xlim([-10 10]);
        %
        subplot(h(2)); hold on;
        title(['Eigenpose: ' num2str(nn)],'FontSize',16);
        for m = 1:Np
            plot3(poses_movie(m,1,n),poses_movie(m,2,n),poses_movie(m,3,n),'.','MarkerSize',18,'Color',cval(m,:));
        end
        %xlim([min(min(poses_movie(:,1,:))) max(max(poses_movie(:,1,:)))]);
        %ylim([min(min(poses_movie(:,2,:))) max(max(poses_movie(:,2,:)))]);
        %zlim([min(min(poses_movie(:,3,:))) max(max(poses_movie(:,3,:)))]);
        xlabel('X','FontSize',16);ylabel('Y','FontSize',16);zlabel('Z','FontSize',16);
        view([90 0]); 
        zlim([-10 10]); ylim([-10 10]); xlim([-10 10]);
        %
        pause(0.025); 
        if do_save
           currFrame = getframe(gcf);
           writeVideo(vidObj,currFrame); 
        end
        if n < Nmovie
            subplot(h(1)); cla;
            subplot(h(2)); cla;
        end
    end
end
if do_save
    close(vidObj);
end




