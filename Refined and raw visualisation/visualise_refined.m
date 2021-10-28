%This code plots 2 3D views and a video of the mouse and a tsne plot with
%kmeans clustered labels 
function[] = visualise_refined(refined, raw, video)
Np = 8;
line_color = 'k';
cval = 'rbbccgmy';
figure('units','normalized','outerposition',[0 0 1 1]); h = subplot(2,2,1); hold on;
views = [[180 90],[90 0]];
poses{1} = refined;
poses{2} = raw;
strings = {'refined','raw'};
if video
    writerObj = VideoWriter('full.avi');
    writerObj.FrameRate = 30;
    open(writerObj);
end
%plotting loop
for n=1:numel(refined(1,1,:))
    counter = 1;
    for n_files = 1:2         
        for h=1:2
            subplot(2,2,counter)
            for i = 1:Np
                plot3(poses{n_files}(i,1,n),poses{n_files}(i,2,n),poses{n_files}(i,3,n),'.','MarkerSize',20,'Color',cval(i));
                hold on
            end
            line([poses{n_files}(1,1,n), poses{n_files}(2,1,n)],[poses{n_files}(1,2,n), poses{n_files}(2,2,n)],[poses{n_files}(1,3,n), poses{n_files}(2,3,n)],'Color','k','LineWidth',0.1); %Link snout with left ear
            line([poses{n_files}(1,1,n), poses{n_files}(3,1,n)],[poses{n_files}(1,2,n), poses{n_files}(3,2,n)],[poses{n_files}(1,3,n), poses{n_files}(3,3,n)],'Color','k','LineWidth',0.1); %Link snout with right ear
            line([poses{n_files}(2,1,n), poses{n_files}(4,1,n)],[poses{n_files}(2,2,n), poses{n_files}(4,2,n)],[poses{n_files}(2,3,n), poses{n_files}(4,3,n)],'Color','k','LineWidth',0.1); %Link front implant base with left ear
            line([poses{n_files}(2,1,n), poses{n_files}(5,1,n)],[poses{n_files}(2,2,n), poses{n_files}(5,2,n)],[poses{n_files}(2,3,n), poses{n_files}(5,3,n)],'Color','k','LineWidth',0.1); %Link back implant base with left ear
            line([poses{n_files}(3,1,n), poses{n_files}(4,1,n)],[poses{n_files}(3,2,n), poses{n_files}(4,2,n)],[poses{n_files}(3,3,n), poses{n_files}(4,3,n)],'Color','k','LineWidth',0.1); %Link back implant base with right ear
            line([poses{n_files}(3,1,n), poses{n_files}(5,1,n)],[poses{n_files}(3,2,n), poses{n_files}(5,2,n)],[poses{n_files}(3,3,n), poses{n_files}(5,3,n)],'Color','k','LineWidth',0.1); %Link back implant base with right ear
            line([poses{n_files}(3,1,n), poses{n_files}(6,1,n)],[poses{n_files}(3,2,n), poses{n_files}(6,2,n)],[poses{n_files}(3,3,n), poses{n_files}(6,3,n)],'Color','k','LineWidth',0.1); %Link neck base with right ear
            line([poses{n_files}(2,1,n), poses{n_files}(6,1,n)],[poses{n_files}(2,2,n), poses{n_files}(6,2,n)],[poses{n_files}(2,3,n), poses{n_files}(6,3,n)],'Color','k','LineWidth',0.1); %Link neck base with left ear
            line([poses{n_files}(7,1,n), poses{n_files}(6,1,n)],[poses{n_files}(7,2,n), poses{n_files}(6,2,n)],[poses{n_files}(7,3,n), poses{n_files}(6,3,n)],'Color','k','LineWidth',0.1); %Link neck base with midpoint
            line([poses{n_files}(7,1,n), poses{n_files}(8,1,n)],[poses{n_files}(7,2,n), poses{n_files}(8,2,n)],[poses{n_files}(7,3,n), poses{n_files}(8,3,n)],'Color','k','LineWidth',0.1); %Link midpoint with tail base

            xlabel('X'); ylabel('Y'); zlabel('Z');
            title([num2str(n) '     ' strings{n_files}])
            view(views(h*2-1),views(h*2))
            xlim([-30 30]); ylim([-30 30]); zlim([-5 40]);
            counter = counter +1;
            hold on
        end
    end % end file loop
    pause(0.1)
    if video
        F = getframe(gcf);
        writeVideo(writerObj, F);
        clear F
    end
    clf;
end %end frameloop
if video
    close(writerObj);
end
end %end function