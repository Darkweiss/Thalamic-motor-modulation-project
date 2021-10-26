% simple analysis of NOR behaviour for 3 objects

close all
clear all

%data for mouse 1, one trial
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
    nnan = sum(isnan(snout(1,:)));
    subplot(1,3,i)
    plot(snout(1,:),snout(2,:),'.')
    axis([-25 25 -25 25])
    title(sprintf('%s: nNAN=%d',object{i},nnan))
    % quantify distance travelled:
%     dist(i) = sum(sqrt(sum(diff(snout,[],2).^2,1)));
end

% figure
% bar(dist)
% title('Distance travelled')
% xlabel('object')
    
