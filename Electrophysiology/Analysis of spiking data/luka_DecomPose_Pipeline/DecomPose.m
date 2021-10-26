function [coeffs,nan_idx] = DecomPose(file,video,vec,visualise,makemovie)

% AIM: decompose 3D pose into rigid motion coefficients (x,y,z location;
% yaw,roll, pitch angle) and "shape" coefficients
% RSP OCt 2021
%
% Inputs:
%   file - triangulation .mat file containing 'x': 3D array(Nlandmarks,Ncoords,Nframes)
%   video - video file corresponding to the triangulation file (or [])
%   vec - eigenvectors of shape (AxB; A = Nlandmarks*Ncoords; B=dimensions
%   of shape (=Nshape)
%   visualise (false/number) - if not false, for each frame, animate the
%   3Dpose, show coeffs and then pause with pause duration = visualise
%   makemovie (false/number) - if true, make movie of first 'makemovie' frames and return as 'mh'
% Outputs:
%   coeffs - matrix: Nframes x Ncoeffs; Ncoeffs = 6 + Nshape


%% load and deNAN the data

% Load data and check for consistency:
x = file;
[Nlandmarks,Ncoords,Nframes] = size(x);
Nshape = size(vec,2);
if size(vec,1)~=Nlandmarks*Ncoords
    error('size of vec not compatible with data in file')
end
if makemovie && ~visualise
    visualise = true;
end

% Check for NANs:
Nnans = 0;
frameisnan = false(1,Nframes);
for j = 1:Nframes
    if sum(sum(isnan(x(:,:,j))))>0
        frameisnan(j) = true;
    end
end
find(frameisnan)
nan_idx = find(frameisnan);
clear j
x(:,:,find(frameisnan)) = [];
Nnans = sum(frameisnan);
fprintf('file %s\nNnans=%d out of Nframes=%d (%.1fpercent)\n',file,Nnans,Nframes,100*Nnans/Nframes)
Nframescumnan = Nframes;
Nframes = size(x,3);
clear Nnans

%% Procrustes
refpose = x(:,:,1);
refpose = refpose - ones(Nlandmarks,1)*mean(refpose);
posepro = zeros(size(x));
posedt = zeros(size(x));
centroid = zeros(Nframes,Ncoords);
for i = 1:Nframes
    pose = x(:,:,i);
    centroid(i,:) = mean(pose);
    posedt(:,:,i) = pose - ones(Nlandmarks,1)*centroid(i,:);
    [d(i),tmp,~] = procrustes(refpose,pose,'Scaling',false,'Reflection',false);
    posepro(:,:,i) = tmp;
end
poseprors = reshape(posepro,Nlandmarks*Ncoords,Nframes)';
clear i pose tmp

%% calculate the breakdown coefficients
thetas0 = [1 0 0];  % radians
thetas = zeros(Nframes,Ncoords);
pc = zeros(Nframes,Nshape);

for i = 1:Nframes
    tmp = x(:,:,i) - ones(Nlandmarks,1)*centroid(i,:);
    thetas(i,:) = (180/pi)*fminunc(@(thetas) myerr(thetas,tmp',refpose'),thetas0);    % degrees
    pc(i,:) = (poseprors(i,:)-mean(poseprors))*vec;
end
clear i tmp
coeffs = [centroid thetas pc];

 

%% visualisation of procrustes breakdown

if visualise
    if makemovie
        figure('units','normalized','outerposition',[0 0.05 1 .95])
%         figure('units','pixels','outerposition',[0 100 540 460])
        axis off
        Nframescumnan = makemovie;
%         mh(Nframescumnan) = struct('cdata',[],'colormap',[]);
        v = VideoWriter('test.avi');
        v.FrameRate = 5;
        open(v)
    else
        figure('units','normalized','outerposition',[0 0.05 1 .95])
%         mh = [];
    end
    if ~isempty(video)
        vid = VideoReader(video);
    end
    tmpx = x(:,1,:); 
    tmpy = x(:,2,:);
    tmpz = x(:,3,:);
    minx = prctile(tmpx(:),1);
    maxx = prctile(tmpx(:),99);
    miny = prctile(tmpy(:),1);
    maxy = prctile(tmpy(:),99);
    minz = prctile(tmpz(:),1);
    maxz = prctile(tmpz(:),99);
    clear tmpx tmpy tmpz    
    tmpx = posedt(:,1,:); 
    tmpy = posedt(:,2,:);
    tmpz = posedt(:,3,:);
    minxdt = prctile(tmpx(:),.1);
    maxxdt = prctile(tmpx(:),99.9);
    minydt = prctile(tmpy(:),.1);
    maxydt = prctile(tmpy(:),99.9);
    minzdt = prctile(tmpz(:),.1);
    maxzdt = prctile(tmpz(:),99.9);
    clear tmpx tmpy tmpz    
    tmpx = posepro(:,1,:);
    tmpy = posepro(:,2,:);
    tmpz = posepro(:,3,:);
    minxpro = prctile(tmpx(:),.1);
    maxxpro = prctile(tmpx(:),99.9);
    minypro = prctile(tmpy(:),.1);
    maxypro = prctile(tmpy(:),99.9);
    minzpro = prctile(tmpz(:),.1);
    maxzpro = prctile(tmpz(:),99.9);
    clear tmpx tmpy tmpz
    
    pcprcmin = prctile(pc,1);
    pcprcmax = prctile(pc,99);
    
    markerfacecolor = true;
    i = 0;

    for fnum = 1:Nframescumnan
        
        if ~isempty(video)
%             subplot(3,4,[1 2 5 6])
            subplot('position',[0 0.4 .5 .5])
            vframe = readFrame(vid);
            image(vframe);
            set(gca,'xdir','reverse')
            set(gca,'ydir','normal')
            axis equal off
            title(fnum)
        end
        
        if frameisnan(fnum)
            % frame is nan so can't do dimension reduction
            title(sprintf('%d POSE IS NAN',fnum),'color','r')
            continue
        else
            i = i+1;
        end
        
        pose = x(:,:,i);
        
        if range(pose(:,1)) >  range(pose(:,2))
            usexy = 1;
            minxy = minx;
            maxxy = maxx;
            minxypro = minxpro;
            maxxypro = maxxpro;
            minxydt = minxdt;
            maxxydt = maxxdt;
            xylabel = 'x';
        else
            usexy = 2;
            minxy = miny;
            maxxy = maxy;
            minxypro = minypro;
            maxxypro = maxypro;
            minxydt = minydt;
            maxxydt = maxydt;
            xylabel = 'y';
        end
        
        % plot the "raw" poses
        subplot(3,4,3), cla
        axis equal
        axis([minx maxx miny maxy])
        plot_mouse_landmarks(pose(:,1:2),'-',markerfacecolor)
        xlabel('x'),ylabel('y')
        
        subplot(3,4,4), cla
        axis equal
        axis([minxy maxxy minz maxz])
        plot_mouse_landmarks(pose(:,[usexy 3]),'-',markerfacecolor)
        xlabel(xylabel)
        ylabel('z')
               
        % plot the detranslated poses (centroids removed)
        subplot(3,4,7),cla
        axis equal
        axis([minxdt maxxdt minydt maxydt])
        plot_mouse_landmarks(refpose(:,1:2),'--',false)
        plot_mouse_landmarks(posedt(:,1:2,i),'-',markerfacecolor)
        xlabel('x'),ylabel('y')
        
        subplot(3,4,8), cla
        axis equal
        axis([minxydt maxxydt minzdt maxzdt])
        plot_mouse_landmarks(refpose(:,[usexy 3]),'--',false)
        plot_mouse_landmarks(posedt(:,[usexy 3],i),'-',markerfacecolor)
        xlabel(xylabel)
        
        if range(refpose(:,1)) >  range(refpose(:,2))
            usexy = 1;
            minxy = minx;
            maxxy = maxx;
            xylabel = 'x';
        else
            usexy = 2;
            minxy = miny;
            maxxy = maxy;
            xylabel = 'y';
        end
        
        % plot detranslated, derotated poses (procrustised)
        subplot(3,4,11),cla
        axis equal
        axis([minxpro maxxpro minypro maxypro])
        plot_mouse_landmarks(refpose(:,1:2),'--',false)
        plot_mouse_landmarks(posepro(:,1:2,i),'-',markerfacecolor)
        xlabel('x'),ylabel('y')
        title(sprintf('procrustes error d=%.2f',d(i)))
        
        subplot(3,4,12), cla
        axis equal
        axis([minxypro maxxypro minzpro maxzpro])
        plot_mouse_landmarks(refpose(:,[usexy 3]),'--',false)
        plot_mouse_landmarks(posepro(:,[usexy 3],i),'-',markerfacecolor)
        xlabel(xylabel)
        ylabel('z')
               
%         subplot(3,4,4)
        subplot('position',[0.05 0.05 .1 .2])
        bar(centroid(i,:))
        axis([.5 3.5 -20 20])
        title('Centroid location')
        set(gca,'xticklabel',{'x','y','z'})
        
%         subplot(3,4,7)
        subplot('position',[.2 0.05 .1 .2])
        bar(thetas(i,:))
        axis([.5 3.5 -180 180])
        title('Euler angles')
        set(gca,'xticklabel',{'yaw','roll','pitch'})
        
%         subplot(3,4,10)
        subplot('position',[.35 0.05 .1 .2])
        bar(pc(i,:))
        axis([.5 3.5 min(pcprcmin) max(pcprcmax)])
        title('Shape PCs')
        
        drawnow
        pause(visualise)
        if makemovie
%             mh(fnum) = getframe(gcf);
            frame = getframe(gcf);
            writeVideo(v,frame);
        end
    end
    close(v)
    
%     figure
%     movie(mh,1,5)
end
