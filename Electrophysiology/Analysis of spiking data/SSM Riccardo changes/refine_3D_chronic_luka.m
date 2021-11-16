function[Xfit,b,t] = refine_3D_chronic_luka(X,mean_pose,lambda,P,var_res,make_fig)
%init regularization parameter
alpha_reg = 0.01;
%perform reconstruction
Nshape = numel(lambda);
inlier  = find(~isnan(X(:,1)));
[Nr,Nc] = size(X);
Nbp = size(X,1);
stop_search = false;
options = optimoptions('fminunc','Display','none');
while(~stop_search)
    %init shape parameters
    b0 = zeros(Nshape,1);
    %generate full list of body point subsets
    list_bp = nchoosek(inlier, numel(inlier)-1);
    Nlist = size(list_bp,1);
    C = zeros(1,Nlist);
    %calculate cost for all subsets
    Xfit = repmat(mean_pose,1,1,Nlist);
    R = zeros(3,3,Nlist);
    t = zeros(Nlist,3);
    C = zeros(1,Nlist);
    for n = 1:Nlist
        %
        Xsub = X(list_bp(n,:),:); 
        mean_pose_sub = mean_pose(list_bp(n,:),:);
        for m = 1:Nshape
            Psub{m} = P{m}(list_bp(n,:),:);
        end
        %
        [C0, X0sub_fit, R0, t0] = fit_SSM(b0, Xsub, mean_pose_sub, lambda, Psub, alpha_reg, var_res); %%%just for figure
        b = fminunc(@(b) fit_SSM(b, Xsub, mean_pose_sub, lambda, Psub, alpha_reg, var_res), b0, options);
        [C(n), Xsub_fit, R(:,:,n), t(n,:)] = fit_SSM(b, Xsub, mean_pose_sub, lambda, Psub, alpha_reg, var_res);
        %
        Xfit0 = mean_pose*R0+repmat(t0,Nbp,1); %%%just for figure
        for m = 1:Nshape
            Xfit(:,:,n) = Xfit(:,:,n)+b(m)*P{m};
        end
        Xfit(:,:,n) = Xfit(:,:,n)*R(:,:,n)+repmat(t(n,:),Nbp,1,1);
    end
    %compare with threshold:
    %use var_res and divide distance from each point by
    %it, then chi2^2 should provide reasonable threshold
    [minC, indmin] = min(C);
    TH = chi2inv(0.99,3*numel(inlier)-3); 
    if ((minC<TH) | (numel(inlier)<=4))
        stop_search = true;
        %
        w = zeros(1,1,Nlist);
        w(:,:,:) = (1./C)/sum(1./C);
        wmat = repmat(w,Nr,Nc,1);
        Xfit = sum(Xfit.*wmat,3); 
        %
        w1 = zeros(Nlist,1);
        w1(:) = (1./C)/sum(1./C);
        wmat1 = repmat(w1,1,3);
        t = sum(t.*wmat1);
    else
        inlier = list_bp(indmin,:);
    end 
end
%show results
if make_fig
    fig1 = figure;
    plot3D_test_luka(X,fig1); 
    plot3D_test_luka(Xfit0,fig1);
    title(['mean fit: C = ' num2str(C0)]);
    fig2 = figure;
    plot3D_test_luka(X,fig2); 
    plot3D_test_luka(Xfit,fig2); 
    title(['SSM fit: C = ' num2str(minC)]);
    ginput(); close all;
end

function[C, Xfit, R, t] = fit_SSM(b, X, mu, lambda, P, alpha_reg, var_res)
Nshape = numel(lambda);
%
Xfit0 = mu;
for n = 1:Nshape
    Xfit0 = Xfit0+b(n)*P{n};
end
%
[~, Xfit, tr] = procrustes(X,Xfit0,'Reflection',false, 'Scaling',false);
%
dist = sum((X(:)-Xfit(:)).^2)/var_res;
%
reg = alpha_reg*sum((b.^2)./lambda);
%
C = dist+reg;
%
R = tr.T;
t = tr.c(1,:);