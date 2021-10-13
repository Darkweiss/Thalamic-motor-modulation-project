% simple analysis of NOR behaviour for 3 objects

%close all
%clear all
% triangulated data for the 3 cones, 1 cone/day, 6 trials/mouse/day, 4 mice
% - in data_rbc as a 1x72 cell output from DLC_to_3D_matrix_frames.m

n_mice = 1;
n_objects = 3; %number of objects used
max_trials = 5;

j= n_mice * n_objects * max_trials;

figure
% dist = zeros(1,3);

for i = 1:j
    
   x=data_rbc{i};
   snout = squeeze(x(1,:,:));
   nnan = sum(isnan(snout(1,:)));
   subplot(max_trials,n_objects,i)
   plot(snout(1,:),snout(2,:),'.')
   axis([-25 25 -25 25])
   title(triangulated_file_names{i}(1))
        % quantify distance travelled:
    %     dist(i) = sum(sqrt(sum(diff(snout,[],2).^2,1)));
   
   
end

% figure
% bar(dist)
% title('Distance travelled')
% xlabel('object')
    
