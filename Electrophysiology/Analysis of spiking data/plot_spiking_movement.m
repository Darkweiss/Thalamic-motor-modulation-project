%% this function plots the mouse in 3D with spiking of a single neuron
function[] = plot_spiking_movement(refined,synced_spikes,neuron_id,n_frames,video)
Np = 8;
cval = 'rbbccgmy';
figure('units','normalized','outerposition',[0 0 1 1]); h = subplot(1,2,1); hold on;
views = [[180 90],[90 0]];
poses = refined;
if video == 1
    writerObj = VideoWriter('full.avi');
    writerObj.FrameRate = 30;
    open(writerObj);
end
%plotting loop
for n=1:n_frames
    counter = 1;       
        for h=1:2
            subplot(1,2,counter)
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
            title([num2str(n) '     ' 'refined'])
            view(views(h*2-1),views(h*2))
            xlim([-30 30]); ylim([-30 30]); zlim([-5 40]);
            counter = counter +1;
            hold on
        end
    if synced_spikes(neuron_id,n) > 0
        for i = 1:numel(synced_spikes(neuron_id,n))
            h = plot(20,20,'.', 'MarkerSize',40,'Color','r');
            %playblocking(player);
            %sound(y,Fs*2)
        end
    end
    pause(0.1)
    if video ==1
        F = getframe(gcf);
        writeVideo(writerObj, F);
        clear F
    end
    clf;
end %end frameloop
close(writerObj);
end %end function