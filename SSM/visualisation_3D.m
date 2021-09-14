%This code plots 2 3D views and a video of the mouse and a tsne plot with
%kmeans clustered labels 
%% initialise
Np = 8;
line_color = 'k';
cval = 'rbbccgmy';
figure; h = subplot(1,2,1); hold on;
poses = coordinates_3D;
video = '385 3_2021-07-07-133631-0000.avi';
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
        line([poses(2,1,n), poses(4,1,n)],[poses(2,2,n), poses(4,2,n)],[poses(2,3,n), poses(4,3,n)],'Color','k','LineWidth',0.1); %Link front implant base with left ear
        line([poses(2,1,n), poses(5,1,n)],[poses(2,2,n), poses(5,2,n)],[poses(2,3,n), poses(5,3,n)],'Color','k','LineWidth',0.1); %Link back implant base with left ear
        line([poses(3,1,n), poses(4,1,n)],[poses(3,2,n), poses(4,2,n)],[poses(3,3,n), poses(4,3,n)],'Color','k','LineWidth',0.1); %Link back implant base with right ear
        line([poses(3,1,n), poses(5,1,n)],[poses(3,2,n), poses(5,2,n)],[poses(3,3,n), poses(5,3,n)],'Color','k','LineWidth',0.1); %Link back implant base with right ear
        line([poses(3,1,n), poses(6,1,n)],[poses(3,2,n), poses(6,2,n)],[poses(3,3,n), poses(6,3,n)],'Color','k','LineWidth',0.1); %Link neck base with right ear
        line([poses(2,1,n), poses(6,1,n)],[poses(2,2,n), poses(6,2,n)],[poses(2,3,n), poses(6,3,n)],'Color','k','LineWidth',0.1); %Link neck base with left ear
        line([poses(7,1,n), poses(6,1,n)],[poses(7,2,n), poses(6,2,n)],[poses(7,3,n), poses(6,3,n)],'Color','k','LineWidth',0.1); %Link neck base with midpoint
        line([poses(7,1,n), poses(8,1,n)],[poses(7,2,n), poses(8,2,n)],[poses(7,3,n), poses(8,3,n)],'Color','k','LineWidth',0.1); %Link midpoint with tail base
        
        xlabel('X'); ylabel('Y'); zlabel('Z');
        title(num2str(n))
        view(views(m*2-1),views(m*2))
        xlim([-30 30]); ylim([-30 30]); zlim([-5 40]);       
    end
    
    subplot(2,2,3);
    imshow(read(obj,n))
    
    pause(0.01)
    %clf;
    delete(subplot(2,2,1));
    delete(subplot(2,2,2));
    delete(subplot(2,2,3));

end