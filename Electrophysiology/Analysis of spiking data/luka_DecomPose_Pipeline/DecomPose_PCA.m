function [vec,val] = DecompPose_PCA(files, Nvisualise)
% AIM: Take a cell array of triangulation files and do PCA on the 3D pose
% shape.  That is, on what's left after subtracting off the Procrustes
% components.
% RSP Oct 2021
%
% Inputs
% files is a cell array of filenames.  Each of these is a .mat file
% containing a 3D array 'x' with dimensions: landmarks (A), x/y/z components (B), frames (C)
% Nvisualise = false/N.  if not false, play an animation to show the meaning
% of the N eigenvectors with greatest eigenvalue.
%
% Outputs:
% vec is a matrix of size A*B x A*B with eigenvectors in increasing order
% of eigenvalue
% val is a vector of eigenvalues


Nfiles = numel(files);

%% load and deNAN the data

xall = [];
for i = 1:Nfiles
    
    % Load data and check for consistency:
    x = files{Nfiles};
    if i==1
        [Nlandmarks,Ncoords,Nframes] = size(x);
    else
        [Nlandmarks_tmp,Ncoords_tmp,Nframes_tmp] = size(x);
        if Nlandmarks_tmp~=Nlandmarks
            error('Triangulation arrays must have same dimensions')
        end
        if Ncoords_tmp~=Ncoords
            error('Triangulation arrays must have same dimensions')
        end
        if Nframes_tmp~=Nframes
            error('Triangulation arrays must have same dimensions')
        end
        clear Nlandmarks_tmp Ncoords_tmp Nframes_tmp
    end
    
    % Check for NANs:
    Nnans = 0;
    nans = [];
    for j = 1:Nframes
        if sum(sum(isnan(x(:,:,j))))>0
            nans = [nans j];
        end
    end
    clear j
    x(:,:,nans) = [];
    Nnans = numel(nans);
    whos x
    clear nans
    fprintf('file %s\nNnans=%d out of Nframes=%d (%.1fpercent)\n',files{i},Nnans,Nframes,100*Nnans/Nframes)
    
    % build up array of all data:
    xall = cat(3,xall,x);
end
x = xall;
clear xall;
Nframes = size(x,3);

%% procrustes
refpose = x(:,:,1);
centroid = mean(refpose);
refpose = refpose - ones(Nlandmarks,1)*centroid;
clear centroid
posepro = zeros(size(x));
for i = 1:Nframes
    pose = x(:,:,i);
    [~,tmp,~] = procrustes(refpose,pose,'Scaling',false,'Reflection',false);
    posepro(:,:,i) = tmp;
end
clear i pose tmp

%% PCA
poseprors = reshape(posepro,Nlandmarks*Ncoords,Nframes)';
[vec,val] = eig(cov(poseprors));
val = diag(val);

%% visualise the shape PCs
if Nvisualise
    vecrs = reshape(vec,Nlandmarks,Ncoords,size(vec,2));
    pc = (poseprors-ones(size(poseprors,1),1)*mean(poseprors))*vec(:,end:-1:end-Nvisualise+1);
    mtx = mean(posepro,3);
    mtx = mtx - ones(Nlandmarks,1)*mean(mtx,1);
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
    subplot(3,Nvisualise,1)
    plot(val,'.-')
    subplot(3,Nvisualise,2)
    plot(100*cumsum(val(end:-1:1))/sum(val),'.-')
    imax = 3;
    i = -imax;
    usexy = 2;
    
    % calculate ranges for plots:
    xmin = zeros(1,Nvisualise);
    xmax = zeros(1,Nvisualise);
    ymin = zeros(1,Nvisualise);
    ymax = zeros(1,Nvisualise);
    zmin = zeros(1,Nvisualise);
    zmax = zeros(1,Nvisualise);
    xymin = zeros(1,Nvisualise);
    xymax = zeros(1,Nvisualise);
    usexy = zeros(1,Nvisualise);
    for j = 1:Nvisualise
        tmp = mtx(:,1)*ones(1,2)+pcstd(j)*vecrs(:,1,end-j+1)*[-imax imax];
        xmin(j) = min(tmp(:));
        xmax(j) = max(tmp(:));
        tmp = mtx(:,2)*ones(1,2)+pcstd(j)*vecrs(:,2,end-j+1)*[-imax imax];
        ymin(j) = min(tmp(:));
        ymax(j) = max(tmp(:));
        tmp = mtx(:,3)*ones(1,2)+pcstd(j)*vecrs(:,3,end-j+1)*[-imax imax];
        zmin(j) = min(tmp(:));
        zmax(j) = max(tmp(:));
        if xmax(j)-xmin(j) > ymax(j)-ymin(j)
            usexy(j) = 1;
            xymin(j) = xmin(j);
            xymax(j) = xmax(j);
            xylabel(j) = 'x';
        else
            usexy(j) = 2;
            xymin(j) = ymin(j);
            xymax(j) = ymax(j);
            xylabel(j) = 'y';
        end
    end
    clear tmp
    
    c = 0;
    while(c<10)
        
        if abs(i-3)<10^-6
            di = -.25;
            c = c+1;
        elseif abs(i+3)<10^-6
            di = .25;
        end
        i = i + di;
        
        for j=1:Nvisualise
            
            subplot(3,Nvisualise,Nvisualise+j), cla
            plot_mouse_landmarks(mtx(:,[1 2])+i*pcstd(j)*vecrs(:,[1 2],end-j+1),'-',true)
            xlabel('x'),ylabel('y')
            title(sprintf('PC%d(%.1f)',j,i))
            axis equal
            axis([xmin(j) xmax(j) ymin(j) ymax(j)])
            subplot(3,Nvisualise,2*Nvisualise+j), cla
            plot_mouse_landmarks(mtx(:,[usexy(j) 3])+i*pcstd(j)*vecrs(:,[usexy(j) 3],end-j+1),'-',true)
            xlabel(xylabel(j)),ylabel('z')
            axis([xymin(j) xymax(j) zmin(j) zmax(j)])
            axis equal
        end
        pause(.01)
    end
    clear c i di j
end

