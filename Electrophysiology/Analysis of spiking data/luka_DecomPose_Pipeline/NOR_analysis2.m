% analysis of NOR behaviour 
% developing quantitative measures
% RSP oct 2021
%
% Specifically here:
% 1.  Deal with NANs so that quantitative measures won't just fall over.  NB method here is dodgy in cases
% where there are sequences of several contiguous NAN frames.
% The idea/hope is that SSM will solve that issue.
% 2.  Extraction and visualisation of movement sequences that describe
% variance in the data

close all
clear all

%data for one mouse, one trial
% triangulated data for object 1:
fn{1} = 'C:\Users\mjcssrp\Dropbox (The University of Manchester)\170320\lab and lab meetings\motor state project\video rebecca oct2021\for Rasmus triangulation cones M1\mouse 1_ bottom obj_nor 3\mouse 1_bottom obj_nor 3_triangulated.mat';
object{1} = 'bottom obj';
% triangulated data for object 2:
fn{2} = 'C:\Users\mjcssrp\Dropbox (The University of Manchester)\170320\lab and lab meetings\motor state project\video rebecca oct2021\for Rasmus triangulation cones M1\mouse 1_ref obj_nor 3\mouse 1_ref obj_nor 3_triangulated.mat';
object{2} = 'ref obj';
% triangulated data for object 3:
fn{3} = 'C:\Users\mjcssrp\Dropbox (The University of Manchester)\170320\lab and lab meetings\motor state project\video rebecca oct2021\for Rasmus triangulation cones M1\mouse 1_top obj_nor 3\mouse 1_top obj_nor 3_triangulated.mat';
object{3} = 'top obj';

figure
% dist = zeros(1,3);
for i = 1:3
    load(fn{i})
    snout = squeeze(x(1,:,:));
    subplot(1,3,i)
    plot(snout(1,:),snout(2,:),'k.')
    axis([-25 25 -25 25])
    nnan = sum(isnan(snout(1,:)));
    title(sprintf('%s: nNAN=%d',object{i},nnan))
    hold on
    % deal with NANs
    % first, parse the video into contiguous NAN sequences
    nanstate = false;
    a = 0;
    clear f
    for j = 1:size(snout,2)
        if nanstate==true
            % previous frame was NAN
            if isnan(snout(1,j))
                % add current frame to current NAN sequence
                f{a} = [f{a} j];
            else
                % a NAN sequence stopped in previous frame
                nanstate = false;
            end
        else
            if isnan(snout(1,j))
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
    % now interpolate    
    for a = 1:numel(f)
        for k = 1:3
            snout(k,f{a}) = interp1([f{a}(1)-1 f{a}(end)+1],snout(k,[f{a}(1)-1 f{a}(end)+1]),f{a},'linear');
        end
        plot(snout(1,f{a}),snout(2,f{a}),'ro')
        plot(snout(1,f{a}(1)-1),snout(2,f{a}(1)-1),'go',snout(1,f{a}(end)+1),snout(2,f{a}(end)+1),'go')
        clear k
    end
    clear a
    % repeat for all landmarks
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

    % check
%     plot(squeeze(x(1,1,:)),squeeze(x(1,2,:)),'bsq')
                
end

% Now have a deNANed 'snout'.  can proceed to further analyse...


%% PCA on poses
% correct for translation:
xx = zeros(size(x));
centroid = mean(x,1);
for i = 1:size(x,1)
    xx(i,:,:) = x(i,:,:) - centroid;
end
% xx = x;
pose = reshape(xx,size(xx,1)*size(xx,2),size(xx,3))';
[vec,val] = eig(cov(pose));
figure
subplot(2,2,1)
plot(diag(val),'.-')
subplot(2,2,2)
plot(vec(:,end-1:end))
subplot(2,2,3)
clear z
z(:,1) = pose*vec(:,end);
z(:,2) = pose*vec(:,end-1);
plot(z(:,1),z(:,2),'.')
xlabel('PC1')
ylabel('PC2')
subplot(2,2,4)
m = mean(xx,3);
pc1 = reshape(vec(:,end),6,3);
pc2 = reshape(vec(:,end-1),6,3);
pc3 = reshape(vec(:,end-2),6,3);
di = 0.5;
figure
connect = true;
pc = pc3;
for i =  -20:di:20
    clf
    subplot(2,2,1)
    plot_mouse_landmarks(m(:,[1 2])+i*pc(:,[1 2]),connect)
    xlabel('x'),ylabel('y')
    axis equal
    axis([-20 20 -20 20])
    subplot(2,2,2)
    plot_mouse_landmarks(m(:,[1 3])+i*pc(:,[1 3]),connect)
    xlabel('x'),ylabel('z')
    axis([-20 20 -10 10])
    axis equal
    subplot(2,2,3)
    plot_mouse_landmarks(m(:,[2 3])+i*pc(:,[2 3]),connect)
    xlabel('y'),ylabel('z')
    axis equal
    axis([-20 20 -10 10])
    subplot(2,2,4)
    plot_mouse_landmarks(m(:,[1 2 3])+i*pc(:,[1 2 3]),connect)
    xlabel('x'),ylabel('y'),zlabel('z')
    axis equal
    axis([-20 20 -20 20 -10 10])
%     pause
     pause(.01)
end


%% parse the timeseries into sequences
Lseq = 30;
seq = zeros(size(snout,2)-Lseq,3*Lseq);
for i = 1:size(snout,2)-Lseq
    o = snout(:,i); % origin
    seq(i,:) = [snout(1,i:i+Lseq-1)-o(1) snout(2,i:i+Lseq-1)-o(2) snout(3,i:i+Lseq-1)-o(3)];
end
clear i o

% PCA on the sequences
[vec,val] = eig(cov(seq));
figure
subplot(2,2,1)
plot(diag(val),'.-')
subplot(2,2,2)
plot(1:3*Lseq,vec(:,end),1:3*Lseq,vec(:,end-1),1:3*Lseq,vec(:,end-2))
subplot(2,2,3)
clear z
z(:,1) = seq*vec(:,end);
z(:,2) = seq*vec(:,end-1);
plot(z(:,1),z(:,2),'.')
xlabel('PC1')
ylabel('PC2')
subplot(2,2,4)
hold on
% visualise the trajectories corresponding to the top PCs:
s = 30*vec(:,end);
plot3(s(1:Lseq),s(Lseq+1:2*Lseq),s(2*Lseq+1:end))
s = 30*vec(:,end-1);
plot3(s(1:Lseq),s(Lseq+1:2*Lseq),s(2*Lseq+1:end))
s = 30*vec(:,end-2);
plot3(s(1:Lseq),s(Lseq+1:2*Lseq),s(2*Lseq+1:end))
xlabel('x'), ylabel('y'), zlabel('z')

%% extension to the above is to use information from all landmarks
clear snout
Lseq = 10;
seq = zeros(size(x,3)-Lseq,size(x,2)*size(x,1)*Lseq);
for i = 1:size(x,3)-Lseq
    % remove translation component
    o = squeeze(x(1,:,i)); % snout origin
    tmp = [x(:,1,i:i+Lseq-1)-o(1) x(:,2,i:i+Lseq-1)-o(2) x(:,3,i:i+Lseq-1)-o(3)];
    seq(i,:) = tmp(:);
end
clear i o tmp

%% PCA on the sequences
[vec,val] = eig(cov(seq));
figure('position',[10 40 1500 740])
subplot(2,2,1)
plot(diag(val),'.-')
subplot(2,2,2)
plot(vec(:,end-1:end))
subplot(2,2,3)
clear z
z(:,1) = seq*vec(:,end);
z(:,2) = seq*vec(:,end-1);
plot(z(:,1),z(:,2),'.')
xlabel('PC1')
ylabel('PC2')
subplot(2,2,4)
% % visualise the mean sequence
% m = mean(seq);
% Nlm = size(x,1);
% m = reshape(m,Nlm,3,Lseq);
% pc = reshape(vec(:,end),Nlm,3,Lseq);
% connect = true;
% for j = -10:10
%     cla
%     for i = 1:Lseq
%         plot_mouse_landmarks(m(:,:,i)+j*pc(:,:,i),connect)
%         xlabel('x'),ylabel('y'),zlabel('z')
%         axis equal
%         axis(.5*[-5 5 -5 5 -5 5])
%         title(j)
%         pause(.1)
%     end
% end
%% cluster the sequences
z = seq*vec(:,end-1:end);
K = 6;
[idx, cc] = kmeans(z,K);
figure
% subplot(2,1,1)
plot(z(:,1),z(:,2),'.')
col = {'r','b','g','c','m','y'};
hold on
for i = 1:K
    plot(z(idx==i,1),z(idx==i,2),'.','color',col{i})
end
% next step: find the cluster centres and plot the corresponding
% trajectories
plot(cc(:,1),cc(:,2),'k*')%,'markersize',5)
Nlm = size(x,1);
figure('position',[10 40 1500 740])
for i = 1:K
    ccseq = cc(i,1)*vec(:,end)+cc(i,2)*vec(:,end-1);
    % seq ~ Nlm x 3 x Lseq
    ccseq = reshape(ccseq,Nlm,3,Lseq);
    tmp = ccseq(:,1,:);
    xmin = -8; %min(tmp(:));
    xmax = 8; %max(tmp(:));
    tmp = ccseq(:,2,:);
    ymin = -8; %min(tmp(:));
    ymax = 8; %max(tmp(:));
    tmp = ccseq(:,3,:);
    zmin = -2; %min(tmp(:));
    zmax = 2; %max(tmp(:));
    for jj = 1:1
    for j = 1:Lseq
        pose = ccseq(:,:,j);
        subplot(2,2,1), hold on
        plot_mouse_landmarks(pose(:,[1 2]),connect)
        xlabel('x'),ylabel('y')
        title(sprintf('cluster %d: t=%d',i,j))
        axis equal
        axis([xmin xmax ymin ymax])
        subplot(2,2,2), hold on
        plot_mouse_landmarks(pose(:,[1 3]),connect)
        xlabel('x'),ylabel('z')
        axis equal
        axis([xmin xmax zmin zmax])
        subplot(2,2,3), hold on
        plot_mouse_landmarks(pose(:,[2 3]),connect)
        xlabel('y'),ylabel('z')
        axis equal
        axis([ymin ymax zmin zmax])
        subplot(2,2,4), 
        plot_mouse_landmarks(pose,connect)
        xlabel('x'),ylabel('y'),zlabel('z')
        axis equal
        axis([xmin xmax ymin ymax zmin zmax])
        hold on
%         pause(.01)
    end
    end
end

return

%% plotting poses
figure('position',[10 40 1500 740])
connect = true;
for i = 1:1000
    pose = x(:,:,i);
    subplot(2,2,1), cla
%     plot(pose(:,1),pose(:,2),'o')
    plot_mouse_landmarks(pose(:,[1 2]),connect)
    xlabel('x'),ylabel('y')
    axis equal
    axis([-25 25 -25 25])
    subplot(2,2,2), cla
%     plot(pose(:,1),pose(:,3),'o')
    plot_mouse_landmarks(pose(:,[1 3]),connect)
    xlabel('x'),ylabel('z')
    axis equal
    axis([-25 25 -10 10])
    subplot(2,2,3), cla
%     plot(pose(:,2),pose(:,3),'o')
    plot_mouse_landmarks(pose(:,[2 3]),connect)
    xlabel('y'),ylabel('z')
    axis equal
    axis([-25 25 -10 10])
    subplot(2,2,4), cla
%     plot(pose(:,2),pose(:,3),'o')
    plot_mouse_landmarks(pose,connect)
    xlabel('x'),ylabel('y'),zlabel('z')
    axis equal
    axis([-25 25 -25 25 -10 10])
    
    pause(.01)
end