function  plot_mouse_landmarks(x,linestyle,markerfacecolor)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% pose is Nlandmark x 3

Nlm = size(x,1);

% if Nlm~=6
%     error;
% end

lm_color = [...
     .8 0 1;
     0 0 1;
     0.5 0.5 1;
     0 1 0;
     1 .8 0;
     1 0 0;
     .4 0 1;
     0 0 .5
     0 1 0];

for i = 1:Nlm
if markerfacecolor
    mfc = lm_color(i,:);
else
    mfc = [0.5 .5 .5];
end
    if size(x,2)==2
        plot(x(i,1),x(i,2),'wo','markerfacecolor',mfc);
    elseif size(x,2)==3
        plot3(x(i,1),x(i,2),x(i,3),'wo','markerfacecolor',mfc);
    else
        error
    end
    hold on
end

if ~isempty(linestyle)
    if size(x,2)==2
        plot([x(1,1),x(2,1)],[x(1,2),x(2,2)],'k','linestyle',linestyle)
        plot([x(1,1),x(3,1)],[x(1,2),x(3,2)],'k','linestyle',linestyle)
        plot([x(4,1),x(5,1)],[x(4,2),x(5,2)],'k','linestyle',linestyle)
        plot([x(5,1),x(6,1)],[x(5,2),x(6,2)],'k','linestyle',linestyle)
    elseif size(x,2)==3
        plot3([x(1,1),x(2,1)],[x(1,2),x(2,2)],[x(1,3),x(2,3)],'k','linestyle',linestyle)
        plot3([x(1,1),x(3,1)],[x(1,2),x(3,2)],[x(1,3),x(3,3)],'k','linestyle',linestyle)
        plot3([x(4,1),x(5,1)],[x(4,2),x(5,2)],[x(4,3),x(5,3)],'k','linestyle',linestyle)
        plot3([x(5,1),x(6,1)],[x(5,2),x(6,2)],[x(5,3),x(6,3)],'k','linestyle',linestyle)
    else
        error     
    end
end
