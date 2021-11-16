function[] = simulate_data_fig(X,tt)
[Np,~,N] = size(X);
figure; hold on;
colorstring = 'kbgrycmkrgkbgryc';

%c = rand(Np,3);
%c = [linspace(0,1,Np)' linspace(1,0,Np)' zeros(Np,1)]; 
for n = 1:Np
   % plot3(squeeze(X(n,1,:)),squeeze(X(n,2,:)),squeeze(X(n,3,:)),'.','Color',c(n,:),'MarkerSize',12)
   plot3(squeeze(X(n,1,:)),squeeze(X(n,2,:)),squeeze(X(n,3,:)),'.','Color',colorstring(n),'MarkerSize',12)
end
view(10,20);
value_lim = [-7.5 7.5];
xlim(value_lim);
ylim(value_lim);
zlim(value_lim);
title(tt);
end
