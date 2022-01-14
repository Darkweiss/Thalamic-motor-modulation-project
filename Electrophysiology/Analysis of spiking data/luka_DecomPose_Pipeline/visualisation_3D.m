%This code plots 2 3D views and a video of the mouse and a tsne plot with
%kmeans clustered labels 
%% initialise
Np = 7;
line_color = 'k';
cval = 'rbbcgmrbbcgm';
figure; h = subplot(1,2,1); hold on;
poses = final_landmarks{2};
video = 'C:\Ephys data\Chronic ephys\Chronic_mouse6_383781\bodycams\Day4\Camera_3_trial_2_2021-11-09-143329-0000.avi';
obj = VideoReader([video]);
views = [[180 90],[90 0]];

%% plotting loop

figure('units','normalized','outerposition',[0 0 1 1])


for n=1:5400
    for m=1:2
        subplot(2,2,m)
        for i = 1:Np
            plot3(poses(i,1,n),poses(i,2,n),poses(i,3,n),'.','MarkerSize',20,'Color',cval(i));
            hold on
        end
 line([poses(1,1,n), poses(2,1,n)],[poses(1,2,n), poses(2,2,n)],[poses(1,3,n), poses(2,3,n)],'Color','k','LineWidth',0.1); %Link snout with left ear
 line([poses(1,1,n), poses(3,1,n)],[poses(1,2,n), poses(3,2,n)],[poses(1,3,n), poses(3,3,n)],'Color','k','LineWidth',0.1); %Link snout with right ear
 line([poses(2,1,n), poses(4,1,n)],[poses(2,2,n), poses(4,2,n)],[poses(2,3,n), poses(4,3,n)],'Color','k','LineWidth',0.1); %Link left ear with neck base
 line([poses(3,1,n), poses(4,1,n)],[poses(3,2,n), poses(4,2,n)],[poses(3,3,n), poses(4,3,n)],'Color','k','LineWidth',0.1); %Link neck base with right ear
 line([poses(4,1,n), poses(5,1,n)],[poses(4,2,n), poses(5,2,n)],[poses(4,3,n), poses(5,3,n)],'Color','k','LineWidth',0.1); %Link neck base with middle back
 line([poses(5,1,n), poses(6,1,n)],[poses(5,2,n), poses(6,2,n)],[poses(5,3,n), poses(6,3,n)],'Color','k','LineWidth',0.1); %Link middle back with tail base

        xlabel('X'); ylabel('Y'); zlabel('Z');
        title(num2str(n))
        view(views(m*2-1),views(m*2))
        xlim([-30 30]); ylim([-30 30]); zlim([-5 40]);       
    end
    
    subplot(2,2,3);
    imshow(read(obj,n))
    
    pause(0.001)
    %clf;
    delete(subplot(2,2,1));
    delete(subplot(2,2,2));
    delete(subplot(2,2,3));

end