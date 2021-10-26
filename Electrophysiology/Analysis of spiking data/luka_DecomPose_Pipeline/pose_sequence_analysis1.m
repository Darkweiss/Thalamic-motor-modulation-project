% analysis of NOR behaviour 
% developing quantitative measures
% RSP oct 2021
%
% Specifically here:
% 1.  Extraction and visualisation of movement sequences that describe
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

%% parse the timeseries into sequences
Lseq = 20;
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
%% cluster the sequences
z = seq*vec(:,end-2:end);
K = 6;
[idx, cc] = kmeans(z,K);
figure
% subplot(2,1,1)
plot3(z(:,1),z(:,2),z(:,3),'.')
col = {'r','b','g','c','m','y'};
hold on
for i = 1:K
    plot3(z(idx==i,1),z(idx==i,2),z(idx==i,3),'.','color',col{i})
end
%% next step: find the cluster centres and plot the corresponding
% trajectories
plot(cc(:,1),cc(:,2),'k*')%,'markersize',5)
Nlm = size(x,1);
figure('position',[10 40 1500 740])
connect = true;
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
    zmin = -1; %min(tmp(:));
    zmax = 1; %max(tmp(:));
    for jj = 1:2
        clf
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
        pause(.01)
    end
    end
end

% reflection
% i'm seeing trajectories oriented in different directions
% probably want to factor this out (will get rid of 2 dimensions)
% how? hmm