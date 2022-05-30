%%
poses = mouse3D;
colours = 'rbbggcmkkkk';
figure
for i = 1:2000
    h1 = subplot(1,2,1);
    for n = 1:numel(poses(:,1,1))
        plot3(poses(n,1,i),poses(n,2,i),poses(n,3,i),'.','Color',colours(n),'MarkerSize',20)       
        hold on
    end
    %lines
    line([poses(1,1,i), poses(2,1,i)],[poses(1,2,i), poses(2,2,i)],[poses(1,3,i), poses(2,3,i)],'Color','k','LineWidth',0.1); %Link snout with left ear
    line([poses(1,1,i), poses(3,1,i)],[poses(1,2,i), poses(3,2,i)],[poses(1,3,i), poses(3,3,i)],'Color','k','LineWidth',0.1); %Link snout with right ear
    line([poses(7,1,i), poses(3,1,i)],[poses(7,2,i), poses(3,2,i)],[poses(7,3,i), poses(3,3,i)],'Color','k','LineWidth',0.1); %Link neck base with right ear    
    line([poses(7,1,i), poses(2,1,i)],[poses(7,2,i), poses(2,2,i)],[poses(7,3,i), poses(2,3,i)],'Color','k','LineWidth',0.1); %Link neck base with right ear
    line([poses(5,1,i), poses(3,1,i)],[poses(5,2,i), poses(3,2,i)],[poses(5,3,i), poses(3,3,i)],'Color','k','LineWidth',0.1); %Link mplant base with right ear   
    line([poses(4,1,i), poses(2,1,i)],[poses(4,2,i), poses(2,2,i)],[poses(4,3,i), poses(2,3,i)],'Color','k','LineWidth',0.1); %Link implant base with left ear
    line([poses(4,1,i), poses(6,1,i)],[poses(4,2,i), poses(6,2,i)],[poses(4,3,i), poses(6,3,i)],'Color','k','LineWidth',0.1); %Link implant base with left ear
    line([poses(5,1,i), poses(6,1,i)],[poses(5,2,i), poses(6,2,i)],[poses(5,3,i), poses(6,3,i)],'Color','k','LineWidth',0.1); %Link implant base with cable
    line([poses(4,1,i), poses(6,1,i)],[poses(4,2,i), poses(6,2,i)],[poses(4,3,i), poses(6,3,i)],'Color','k','LineWidth',0.1); %Link implant base with cable
    line([poses(7,1,i), poses(8,1,i)],[poses(7,2,i), poses(8,2,i)],[poses(7,3,i), poses(8,3,i)],'Color','k','LineWidth',0.1); %Link implant base with left ear
    line([poses(8,1,i), poses(9,1,i)],[poses(8,2,i), poses(9,2,i)],[poses(8,3,i), poses(9,3,i)],'Color','k','LineWidth',0.1); %Link implant base with left ear
% 
%     for j = 1:14
%         plot3(coordinates_all{1}(j,1),coordinates_all{1}(j,2),coordinates_all{1}(j,3),'.','Color','Red','MarkerSize',20)
%     end

    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    %limits
    xlim([-15 15]);
    ylim([-15 15]);
    zlim([-10 10]);
    view([0 90])
    


    h2 = subplot(1,2,2);
    bar(motor.locomotion(i))
    ylim([0 0.8])
    title('Locomotion')

        %video
    if vid_path
        F(i) = getframe(gcf) ;
        drawnow
    end
    pause(0.03)
    cla(h1)
    cla(h2)
end

%%
%video
if vid_path
    writerObj = VideoWriter([vid_path name]);
    writerObj.FrameRate = 15;
    % set the seconds per image
    % open the video writer
    open(writerObj);
    % write the frames to the video
    for i=1:numel(F)
        % convert the image to a frame
        frame = F(i) ;
        writeVideo(writerObj, frame);
    end
    % close the writer object
    close(writerObj);
end
end