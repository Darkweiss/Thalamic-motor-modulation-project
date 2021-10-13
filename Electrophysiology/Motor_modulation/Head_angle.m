poses = refined2;
v = [1,0];
for i = 1:numel(poses(1,1,:))
     u{i} = poses(1,1:2,i) - poses(2,1:2,i);
% 
%     dotUV = dot(u, v);
%     normU = norm(u);
%     normV = norm(v);
%     
%     theta(i) = acos(dotUV/(normU * normV));

   angle = atan2d(x1*y2-y1*x2,x1*x2+y1*y2);

end
