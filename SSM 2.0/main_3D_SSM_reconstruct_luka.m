function[Data_3D_refined,b,T] = main_3D_SSM_reconstruct_luka(data)
%%%%%the final outputs are:
% Data_3D_refined
% b: shape parameters
% T: bosy translation on X,Y,Z axes

%%%%%%%%%%%THIS PART IS ONLY TO GENERATE SIMULATED DATA%%%%%%%%%%%%%%%
%  [Data_3D_original,Data_3D] = simulate_SSM_data_180621(false);
[Data_3D] = data;
[Np,~,N] = size(Data_3D);
%%%%%%%%%%%%%%TRAIN SSM%%%%%%%%%%%%%%%%%%%%%%%%%%%
%take a random fraction of the simulated data to train a SSM
ind_train = randperm(N); 
ind_train = ind_train(1:250);
Data_3D_train =  Data_3D(:,:,ind_train);

%%%%%%%%%%%%%%%%ESTIMATE SSM%%%%%%%%%%%%%%%%%%%%%%%%%%
[mean_pose_3D,lambda,P,var_res] = estimate_SSM_luka(Data_3D_train);
Nshape = numel(lambda);

%%%%%%%%%%%%%RECONSTRUCT SSM%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Xfit = zeros(Np,3,N);  
b = zeros(Nshape,N);
T = zeros(3,N);
make_fig = false;
for n = 1:size(Data_3D,3)
    [Data_3D_refined(:,:,n),b(:,n),T(:,n)] = refine_3D_chronic_luka(Data_3D(:,:,n),mean_pose_3D,lambda,P,var_res,make_fig);
    disp(sprintf('Pose %s of %s',num2str(n),num2str(N)));
end

%%%%%%%%%%%PLOT FINAL RESULTS%%%%%%%%%%%%%%%%%%%%%%
Data_3D_aligned = Alignment_ric(Data_3D, mean_pose_3D);
Data_3D_refined_aligned = Alignment_ric(Data_3D_refined, mean_pose_3D);
simulate_data_fig(Data_3D,'Initial Data 3D');
simulate_data_fig(Data_3D_aligned,'Data 3D Aligned Raw');
simulate_data_fig(Data_3D_refined_aligned,'Data 3D Aligned Refined');
