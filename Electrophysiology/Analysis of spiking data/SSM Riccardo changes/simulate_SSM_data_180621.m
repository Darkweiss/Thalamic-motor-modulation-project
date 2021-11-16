function[X,Xnoise_outliers_missing_rt,Noutliers,Nmissing,A,P] = simulate_SSM_data_180621(show_eigenposes)
%This function simulates 3D data
%INPUTS:
%rotation_translations: if true add rotation and translations to the data
%OUTPUTS:
%X: original uncontamindated data
%Xnoise: data + low amplitude noise
%Xnoise_outliers: data + low amplitude noise + high amplitude outliers
%Xnoise_outliers_missing: data + low amplitude noise + high amplitude
%outliers + missing data

%%%%%%%%%%%%%%%%parameters%%%%%%%%%%%%%%%
% AA=[0.3,0.25,0.15,...
%     0.0985,0.0965,0.0954,0.0929,0.0879,0.0841,0.0834,0.0808,0.08060,...
%     0.0748,0.0726,0.0674,0.0637,0.0609,0.0583,0.031,0.0303,0.0298,0.0268,0.0229,0.0195]
%A = [1 0.5 0.1]; %[ones(1,3)]/3; %amplitude of each eigenpose  %% Normalisation  <<---
A = [1 0.5 0.25 0 0];
Nshape = numel(A); %number of eigenposes
N = 1000; %number of poses 
Anoise = 0.05; %noise amplitude    %% <<---
prob_has_outlier = 0.05; %probability of outlier dimension  <----
prob_bp_outlier = 0.1;
Aoutlier = 5; %outlier amplitude
prob_has_missing = 0.05; %probability missing data dimension (aka NaNs)
prob_bp_missing = 0.1;
%%%%%for replicability%%%%%%%%%%%
%rng(3); 

%%%%%%%%%%%generate mean pose%%%%%%%%%%%%%%%%%%
%mean_pose = generate_objects('poly16',0);
mean_pose = generate_objects('L',0);
Np = size(mean_pose,1);
mean_pose = mean_pose - repmat(mean(mean_pose),Np,1);
mean_pose_vec = reshape(mean_pose,3*Np,1); 


% mean(mean_pose)

%%%%%%%%%%%generate eigenposes%%%%%%%%%%%%%%%%%
P0 = randn(3*Np,Nshape); %random eigenposes basis  <-- %% they should be orthogonal 
P0 = P0-repmat(mean(P0),3*Np,1); %remove mean
P = gram_schmidt(P0')'; %orthonormaize eigenposes

% Check the orthogonality
% P(:,2)'*P(:,3) % inner product must be zero

%%%%%%%%%%show eigenposes%%%%%%%%%%%%%%%%%%%%%
%show_eigenposes = true;
if show_eigenposes
    simulate_data_video(mean_pose_vec,P,A);
end

%%%%%% generate data: apply eigenposes%%%%%%%%% 
%generate random shape parameters for Nshape eigenposes
for n = 1:Nshape
    % this should be randomly generated from Gaussian distribtuion with varaince equals to Lambdas
    b(:,n) =A(n)*randn(N,1);
end
Xvec = repmat(mean_pose_vec,1,N);
Xvec = Xvec + P*b';
X = reshape(Xvec,Np,3,N);

%%%%generate data: apply translations & rotations%%%%%%%
T = randn(N,3); %translations
theta = unifrnd(-pi,pi,N,3);
for n = 1:N   
    R = rotate_pose(theta(n,1),theta(n,2),theta(n,3));
    X_rt(:,:,n) = squeeze(X(:,:,n))*R + repmat(T(n,:),Np,1);
end

    
%%%%%%%%%%%Add noise%%%%%%%%%%%
Xnoise = X + Anoise*randn(Np,3,N);
Xnoise_rt = X_rt + Anoise*randn(Np,3,N);

%%%%%%%%%%Add outliers%%%%%%%%%
Xnoise_outliers = Xnoise;
Xnoise_outliers_rt = Xnoise_rt;
has_outlier = binornd(1,prob_has_outlier,1,N);
for n = 1:N
    if has_outlier(n)
       ind = find(binornd(1,prob_bp_outlier,1,Np));
       if numel(ind)
          temp = Aoutlier*randn(numel(ind),3);
          Xnoise_outliers(ind,:,n) = Xnoise_outliers(ind,:,n) + temp;
          Xnoise_outliers_rt(ind,:,n) = Xnoise_outliers_rt(ind,:,n) + temp;
       else
          has_outlier(n) = 0; 
       end
    end
end

%%%%%Add missing data (NaNs)%%%%
Xnoise_outliers_missing = Xnoise_outliers;
Xnoise_outliers_missing_rt = Xnoise_outliers_rt;
has_missing = binornd(1,prob_has_missing,1,N);
for n = 1:N
    if has_missing(n)
       ind = find(binornd(1,prob_bp_missing,1,Np));
       if numel(ind)
          Xnoise_outliers_missing(ind,:,n) = NaN;
          Xnoise_outliers_missing_rt(ind,:,n) = NaN;
       else
          has_missing(n) = 0; 
       end
    end
end


%%%%%%calculate number poses with outliers and missing data%%%%%
Noutliers = sum(has_outlier&(~has_missing));
Nmissing = sum(has_missing);

%generate figure;
make_figure = false;
if make_figure
    simulate_data_fig(X,'Poses');
    simulate_data_fig(X_rt,'Poses R T');
    simulate_data_fig(Xnoise,'Poses+Noise');
    simulate_data_fig(Xnoise_rt,'Poses+Noise R T')
    simulate_data_fig(Xnoise_outliers_missing,['Poses+Noise+Outliers(n = ' num2str(Noutliers) ')+NaNs(n = ' num2str(Nmissing)  ') of n = ' num2str(N)]);
    simulate_data_fig(Xnoise_outliers_missing_rt,['Poses+Noise+Outliers R T(n = ' num2str(Noutliers) ')+NaNs(n = ' num2str(Nmissing)  ') of n = ' num2str(N)]);
end

%%%%%%%%%%%%%%%%%%%%%%%SUBFUNCTIONS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



