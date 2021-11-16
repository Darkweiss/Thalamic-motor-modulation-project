function[mean_pose_3D,lambda,P,var_res] = estimate_SSM_luka(Data_3D)

%estimate the SSM
mean_pose_3D = Estimate_mean_RANSAC_ric(Data_3D, false);
Data_3D = Alignment_ric(Data_3D, mean_pose_3D);
K = 5;
Data_3D = Near_NaN_Euclidian_ric(Data_3D, K, false);
[lambda,P,var_res] = pPCA_luka(Data_3D, false);