function[X] = generate_objects(which_obj, graph)
if strcmp(which_obj, 'cube')
   X = [1 1 1; 1 -1 1; -1 1 1; -1 -1 1];
   X = cat(1,X,[1 1 -1; 1 -1 -1; -1 1 -1; -1 -1 -1]);
elseif strcmp(which_obj, 'L')
   X = [1 0 1; -1 1 1; -1 0 1; 1 2 1; 0 2 1; 0 1 1];
   X = cat(1,X,[1 0 0; -1 1 0; -1 0 0; ; 1 2 0; 0 2 0; 0 1 0]); 
elseif strcmp(which_obj, 'poly16')
   X = [1 -1 1; 0 -1 1; 1 2 1; 0 2 1];
   X = cat(1,X,[1 -1 0; 0 -1 0; 1 2 0; 0 2 0]);
   %
   X = cat(1,X,[2 0 1; 2 1 1; -1 0 1; -1 1 1]);
   X = cat(1,X,[2 0 0; 2 1 0; -1 0 0; -1 1 0]);
elseif strcmp(which_obj, 'plus')
   X = [1 1 1; 1 0 1; 0 1 1; 0 0 1];
   X = cat(1,X,[1 1 0; 1 0 0; 0 1 0; 0 0 0]);
   %
   X = cat(1,X,[1 -1 1; 0 -1 1; 1 2 1; 0 2 1]);
   X = cat(1,X,[1 -1 0; 0 -1 0; 1 2 0; 0 2 0]);
   %
   X = cat(1,X,[2 0 1; 2 1 1; -1 0 1; -1 1 1]);
   X = cat(1,X,[2 0 0; 2 1 0; -1 0 0; -1 1 0]);
else 
    disp('valid options: cube, L, poly16, plus');
    return;
end
if graph
    figure; hold on;
    N = size(X,3);
    for n = 1:N
        plot3(X(:,1), X(:,2), X(:,3),'b.','MarkerSize',12); 
    end
    view(30,10);
    xlim([min(X(:,1))-1 max(X(:,1))+1]);
    ylim([min(X(:,2))-1 max(X(:,2))+1]);
    zlim([min(X(:,3))-1 max(X(:,3))+1]);
    xlabel('X'); ylabel('Y');
end