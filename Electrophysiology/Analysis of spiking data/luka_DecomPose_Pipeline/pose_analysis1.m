% analysis of 3D pose
% developing quantitative measures
% RSP oct 2021
%
% STATUS QUO 191021 after some successful development:
% this script is for visualisation-geared analysis
% Animates the 3D poses - to view the data
% procrustes analysis to parse pose into allocentric coordinate frame and
% shape
% Visualisation of 3D pose and its procrustes breakdown, showing components
% of location (coords of the centroid), rigid angle (yaw, roll, pitch) and
% the principal components of shape (shape defined as difference between 3D
% pose and the procrustes version).
%
% REFLECTION 191021
% 1. the meaning of the centroid/angles is clear from the plots.  that of the
% PCs is not - needs animations to show the effects of each eigenvector on
% shape. DONE
% 2. quality could be improved with more landmarks.  eg, jumping of coefficients at times.
% given that 9 parameters are being fitted to n=18; there is going to be
% error.  Conceptually, there is little information to capture any roll of the trunk or
% roll of head relative to trunk.
% 3. a next step is to estimate the Prob dist of each coefficient and to
% compare these distributions across conditions.
% 4. another next step is to apply this approach to the description of
% motion - defined as changes in 3D pose.


close all
clear all

%data for one mouse, one trial
% triangulated data for object 1:
fn{1} = 'C:\Users\mjcssrp\Dropbox (The University of Manchester)\170320\lab and lab meetings\motor state project\video rebecca oct2021\for Rasmus triangulation cones M1\mouse 1_ bottom obj_nor 3\mouse 1_bottom obj_nor 3_triangulated.mat';
object{1} = 'bottom obj';
video{1} = 'C:\Users\mjcssrp\Dropbox (The University of Manchester)\170320\lab and lab meetings\motor state project\video rebecca oct2021\for Rasmus triangulation cones M1\mouse 1_ bottom obj_nor 3\383784 385 nor 3_2021-09-15.mp4';
% triangulated data for object 2:
fn{2} = 'C:\Users\mjcssrp\Dropbox (The University of Manchester)\170320\lab and lab meetings\motor state project\video rebecca oct2021\for Rasmus triangulation cones M1\mouse 1_ref obj_nor 3\mouse 1_ref obj_nor 3_triangulated.mat';
object{2} = 'ref obj';
video{2} = '383784 093 nor 3_2021-09-13.mp4';
% triangulated data for object 3:
fn{3} = 'C:\Users\mjcssrp\Dropbox (The University of Manchester)\170320\lab and lab meetings\motor state project\video rebecca oct2021\for Rasmus triangulation cones M1\mouse 1_top obj_nor 3\mouse 1_top obj_nor 3_triangulated.mat';
object{3} = 'top obj';
video{3} = '383784 093 nor 3_2021-09-14.mp4';

%% load and deNAN the data
xall = [];
for i = 1:3
    load(fn{i})
    
    % first, parse the video into contiguous NAN sequences
    for b = 1:size(x,1)
        nanstate = false;
        a = 0;
        clear f
        for j = 1:size(x,3)
            if nanstate==true
                % previous frame was NAN
                if isnan(x(b,1,j))
                    % add current frame to current NAN sequence
                    f{a} = [f{a} j];
                else
                    % a NAN sequence stopped in previous frame
                    nanstate = false;
                end
            else
                if isnan(x(b,1,j))
                    % start a new NAN sequence
                    a = a+1;
                    f{a} = j;
                    nanstate = true;
                else
                    % no need for action
                end
            end
        end
        clear nanstate a j
        if exist('f','var')
            for a = 1:numel(f)
                for k = 1:3
                    tmp = interp1([f{a}(1)-1 f{a}(end)+1],reshape(x(b,k,[f{a}(1)-1 f{a}(end)+1]),1,2),f{a},'linear');
                    x(b,k,f{a}) = reshape(tmp,1,1,numel(f{a}));
                end
            end
            clear a k tmp
        end
    end
    clear b
    xall = cat(3,xall,x);            
end
x = xall;
clear xall



%% plotting poses
connect = true;
step = 2;
plot_mouse_landmark_movie(x,connect,step)


%% procrustes
connect = true;
refpose = x(:,:,1);
tx = zeros(size(x));
for i = 1:size(x,3)
    pose = x(:,:,i);
    [~,tmp,transform] = procrustes(refpose,pose,'Scaling',false,'Reflection',false);
    tx(:,:,i) = tmp;
end
clear i pose tmp %transform
step = 1;
% plot_mouse_landmark_movie(tx,connect,step)

%% visualisation of procrustes breakdown
refpose = x(:,:,1);
refpose = refpose - ones(6,1)*mean(refpose);
vid = VideoReader(video{1});
framenums = 1:5000;
tmpx = x(:,1,framenums);
tmpy = x(:,2,framenums);
tmpz = x(:,3,framenums);
minx = min(tmpx(:));
maxx = max(tmpx(:));
miny = min(tmpy(:));
maxy = max(tmpy(:));
minz = -1; %min(tmpz(:));
maxz = 10; %max(tmpz(:));
clear tmpx tmpy tmpz

txrs = reshape(tx,size(tx,1)*size(tx,2),size(tx,3))';
[vec,val] = eig(cov(txrs));
pc = txrs*vec(:,end:-1:end-2);
pcprcmin = prctile(pc,5);
pcprcmax = prctile(pc,95);


figure('position',[10 40 1500 740])
markerfacecolor = true;
for fnum = framenums
    
    subplot(4,3,1)
    vframe = readFrame(vid);
    image(vframe);
    set(gca,'xdir','reverse')
    set(gca,'ydir','normal')
    axis equal off
    title(fnum)
    
    pose = x(:,:,fnum);
    
    if range(pose(:,1)) >  range(pose(:,2))
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

    subplot(4,3,2), cla
    axis([minx maxx miny maxy])
    plot_mouse_landmarks(pose(:,1:2),'-',markerfacecolor)
    xlabel('x'),ylabel('y')
    
    subplot(4,3,3), cla
    axis([minxy maxxy minz maxz])
    plot_mouse_landmarks(pose(:,[usexy 3]),'-',markerfacecolor)
    xlabel(xylabel)
    ylabel('z')
    
    centroid = mean(pose);
    pose = pose - ones(6,1)*centroid;
    [d,tmp,transform] = procrustes(refpose,pose,'Scaling',false,'Reflection',false);
    pose_pro = tmp;
    clear tmp transform
        
    subplot(4,3,5),cla
    axis([-10 10 -10 10])
    plot_mouse_landmarks(refpose(:,1:2),'--',false)
    plot_mouse_landmarks(pose(:,1:2),'-',markerfacecolor)
    xlabel('x'),ylabel('y')
        
    subplot(4,3,6), cla
    axis([-10 10 -10 10])
    plot_mouse_landmarks(refpose(:,[usexy 3]),'--',false)
    plot_mouse_landmarks(pose(:,[usexy 3]),'-',markerfacecolor)
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

    subplot(4,3,8),cla
    axis(.5*[-10 10 -20 20])
    plot_mouse_landmarks(refpose(:,1:2),'--',false)
    plot_mouse_landmarks(pose_pro(:,1:2),'-',markerfacecolor)
    xlabel('x'),ylabel('y')
    title(sprintf('d=%.2f',d))
        
    subplot(4,3,9), cla
    axis([-10 10 -10 10])
    plot_mouse_landmarks(refpose(:,[usexy 3]),'--',false)
    plot_mouse_landmarks(pose_pro(:,[usexy 3]),'-',markerfacecolor)
    xlabel(xylabel)
    ylabel('z')
    
        % calculate and plot the breakdown coefficients
    thetas0 = [1 0 0];  % radians
    thetas = (180/pi)*fminunc(@(thetas) myerr(thetas,pose',refpose'),thetas0);    % degrees
    pc = (txrs(fnum,:)-mean(txrs))*vec(:,end:-1:end-2);
    
    subplot(4,3,4)
    bar(centroid)
    axis([.5 3.5 -20 20])
    title('centroid location')
    set(gca,'xticklabel',{'x','y','z'})
    
    subplot(4,3,7)
    bar(thetas)
    axis([.5 3.5 -180 180])
    title('euler angles')
    set(gca,'xticklabel',{'yaw','roll','pitch'})
    
    subplot(4,3,10)
    bar(pc)
    axis([.5 3.5 min(pcprcmin) max(pcprcmax)])
    title('Shape PCs')

    pause(.01)
end

%% visualise the shape PCs
txrs = reshape(tx,size(tx,1)*size(tx,2),size(tx,3))';
[vec,val] = eig(cov(txrs));
vecrs = reshape(vec,size(tx,1),size(tx,2),size(vec,2));
pc = (txrs-ones(size(txrs,1),1)*mean(txrs))*vec(:,end:-1:end-2);
mtx = mean(tx,3);
mtx = mtx - ones(6,1)*mean(mtx,1);
if range(mtx(:,1))>range(mtx(:,2))
    usexy = 1;
    xylabel = 'x';
else
    usexy = 2;
    xylabel = 'y';
end
pcprcmin = prctile(pc,5);
pcprcmax = prctile(pc,95);
pcstd = std(pc);

figure('position',[10 40 1500 740])
subplot(3,3,1)
plot(diag(val),'.-')
subplot(3,3,2)
tmp = diag(val);
plot(100*cumsum(tmp(end:-1:1))/sum(tmp),'.-')
clear tmp
i = -3;
while(true)
    if abs(i-3)<10^-6
        di = -.25;
    elseif abs(i+3)<10^-6
        di = .25;
    end
    i = i + di;
    for j=1:3
        subplot(3,3,3+j), cla
        plot_mouse_landmarks(mtx(:,[1 2])+i*pcstd(j)*vecrs(:,[1 2],end-j+1),'-',true)
        xlabel('x'),ylabel('y')
        title(sprintf('PC%d(%.1f)',j,i))
        axis equal
        axis(.5*[-20 20 -20 20])
        subplot(3,3,6+j), cla
        plot_mouse_landmarks(mtx(:,[usexy 3])+i*pcstd(j)*vecrs(:,[usexy 3],end-j+1),'-',true)
        xlabel(xylabel),ylabel('z')
        axis(.5*[-20 20 -10 10])
        axis equal
    end
    pause(.01)
end

%% development - extract euler angles from pose
refpose = x(:,:,1) - ones(6,1)*mean(x(:,:,1));
pose = x(:,:,1500) - ones(6,1)*mean(x(:,:,1500));
% pose = refpose*rotate3d([0 0 -1],'xyz');
thetas0 = [1 0 0];  % radians
thetas = (180/pi)*fminunc(@(thetas) myerr(thetas,pose',refpose'),thetas0);    % degrees
fiterr = myerr((pi/180)*thetas,v,v0);
alpha = thetas(1);
beta = thetas(2);
gamma = thetas(3);
figure('position',[10 40 1500 740])
subplot(2,2,1), cla
% axis([minx maxx miny maxy])
plot_mouse_landmarks(refpose(:,1:2),'-',true)
axis([-20 20 -20 20])
xlabel('x'), ylabel('y'), title('ref pose')
subplot(2,2,3), cla
% axis([minxy maxxy minz maxz])
plot_mouse_landmarks(refpose(:,[2 3]),'-',true)
axis([-20 20 -10 10])
xlabel('y'), ylabel('z')
subplot(2,2,2), cla
% axis([minx maxx miny maxy])
plot_mouse_landmarks(pose(:,1:2),'-',true)
axis([-20 20 -20 20])
xlabel('x'), ylabel('y'), title('pose')
subplot(2,2,4), cla
% axis([minxy maxxy minz maxz])
plot_mouse_landmarks(pose(:,[2 3]),'-',true)
axis([-20 20 -10 10])
xlabel('y'), ylabel('z')
title(sprintf('alpha=%.2f beta=%.2f gamma=%.2f',alpha,beta,gamma))


%% Analysis of the residual variance post-procrustes
%% PCA on poses
% correct for translation:
tmp = reshape(tx,size(tx,1)*size(tx,2),size(tx,3))';
[vec,val] = eig(cov(tmp));
figure
subplot(2,2,1)
plot(diag(val),'.-')
subplot(2,2,2)
plot(vec(:,end-1:end))
subplot(2,2,3)
clear z
z(:,1) = tmp*vec(:,end);
z(:,2) = tmp*vec(:,end-1);
z(:,3) = tmp*vec(:,end-2);
plot(z(:,1),z(:,2),'.')
xlabel('PC1')
ylabel('PC2')
subplot(2,2,4)
m = mean(tx,3);
pc1 = reshape(vec(:,end),6,3);
pc2 = reshape(vec(:,end-1),6,3);
pc3 = reshape(vec(:,end-2),6,3);
di = 0.25;
%%
figure('position',[10 40 1500 740])
connect = true;
pc = pc3;
for i =  -4:di:4
    clf
    subplot(2,2,1)
    plot_mouse_landmarks(m(:,[1 2])+i*pc(:,[1 2]),connect)
    xlabel('x'),ylabel('y')
    axis equal
    axis(.7*[-20 20 -20 20])
    subplot(2,2,2)
    plot_mouse_landmarks(m(:,[1 3])+i*pc(:,[1 3]),connect)
    xlabel('x'),ylabel('z')
    axis(.7*[-20 20 -10 10])
    axis equal
    subplot(2,2,3)
    plot_mouse_landmarks(m(:,[2 3])+i*pc(:,[2 3]),connect)
    xlabel('y'),ylabel('z')
    axis equal
    axis(.7*[-20 20 -10 10])
    subplot(2,2,4)
    plot_mouse_landmarks(m(:,[1 2 3])+i*pc(:,[1 2 3]),connect)
    xlabel('x'),ylabel('y'),zlabel('z')
    axis equal
    axis([-3 3 -1 7 -0 7])
    pause(.1)
end

%% clustering
% K = 6;
% [idx, cc] = kmeans(z,K);
% figure
% % subplot(2,1,1)
% plot3(z(:,1),z(:,2),z(:,3),'.')
% col = {'r','b','g','c','m','y'};
% hold on
% for i = 1:K
%     plot3(z(idx==i,1),z(idx==i,2),z(idx==i,3),'.','color',col{i})
% end
% figure
% for i = 1:K
%     pose = cc(i,1)*vec(:,end) + cc(i,2)*vec(:,end-1) + cc(i,3)*vec(:,end-2);
%     pose = reshape(pose,6,3);
%     subplot(2,6,i)
%     plot_mouse_landmarks(pose(:,[1 2]),connect)
%     xlabel('x'), ylabel('y')
%     axis([-4 4 -4 4])
%     subplot(2,6,i+6)
%     plot_mouse_landmarks(pose(:,[1 3]),connect)
%     xlabel('x'), ylabel('z')
%     axis([-4 4 -4 4])
% end

