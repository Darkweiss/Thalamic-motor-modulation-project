function[] = plot3D_test_luka(X,fig)
cval = [1 0 0; 0 0 1; 0 0 0.5; 0 1 1; 0 0.5 0.5; 0.75 0 0.25; 0.25 0 0.75; 1 0 1; 0 1 0; 1 0.5 0; 1 1 0];
Np = size(X,1);
N = size(X,3);
if fig == 0
    figure; hold on;
else
   figure(fig); hold on; 
end
for n = 1:N
    %landmarks
    for m = 1:Np
        plot3(X(m,1,n), X(m,2,n), X(m,3,n),'.','MarkerSize',25,'Color',cval(m,:)); 
    end
    %plot limits
    xm = nanmean(X(:,1,1)); ym = nanmean(X(:,2,1)); zm = nanmean(X(:,3,1));
    dxm = 5; dym = 5; dzm = 5; 
    xlim([xm-dxm xm+dxm]); ylim([ym-dym ym+dym]); zlim([zm-dzm zm+dzm]);
end
view(0,45);