
%use this to generate a rotation matrix
function[R] = rotate_pose(thetaX,thetaY,thetaZ)
Rx = [1 0 0; 0 cos(thetaX) -sin(thetaX); 0 sin(thetaX) cos(thetaX)];
Ry = [cos(thetaY) 0 sin(thetaY); 0 1 0; -sin(thetaY) 0 cos(thetaY)];
Rz = [cos(thetaZ) -sin(thetaZ) 0; sin(thetaZ) cos(thetaZ) 0; 0 0 1];
R = Rx*Ry*Rz;
