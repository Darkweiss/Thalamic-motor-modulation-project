function [ R ] = rotate3deuler( angles, convention )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

if numel(angles)~=3
    error(['First argument must be a 3-element (angles) vector'])
end
alpha = angles(1);
beta = angles(2);
gamma = angles(3);

R = zeros(3);

switch convention
    case 'xyz'
        % goldstein appendix A
        % 1st rot (phi, yaw, about z axis); 2nd rot (theta, pitch); 3rd (psi, roll/bank)
        R(1,1) = cos(beta).*cos(alpha);
        R(1,2) = cos(beta).*sin(alpha);
        R(1,3) = -sin(beta);
        
        R(2,1) = sin(gamma).*sin(beta).*cos(alpha) - cos(gamma).*sin(alpha);
        R(2,2) = sin(gamma).*sin(beta).*sin(alpha) + cos(gamma).*cos(alpha);
        R(2,3) = cos(beta).*sin(gamma);

        R(3,1) = cos(gamma).*sin(beta).*cos(alpha) + sin(gamma).*sin(alpha);
        R(3,2) = cos(gamma).*sin(beta).*sin(alpha) - sin(gamma).*cos(alpha);
        R(3,3) = cos(beta).*cos(gamma);

    case 'x'
        % goldstein chapter 4
        % 1st rot (alpha) is around z axis.  new axes x'y'z'
        % 2nd rot (beta) is around x' axis.  new axes x''y''z''
        % 3rd rot (gamma) is around z'' axis.  final axes x'''y'''z'''
        % [x''' y''' z'''] = R*[x y z]
        % cave there is a mistake (!) in Goldstein (3rd edition) eq A.11xyz, R(3,1)
        R(1,1) = cos(gamma).*cos(alpha) - cos(beta).*sin(alpha).*sin(gamma);
        R(1,2) = cos(gamma).*sin(alpha) + cos(beta).*cos(alpha).*sin(gamma);
        R(1,3) = sin(gamma).*sin(beta);
        
        R(2,1) = -sin(gamma).*cos(alpha) - cos(beta).*sin(alpha).*cos(gamma);
        R(2,2) = -sin(gamma).*sin(alpha) + cos(beta).*cos(alpha).*cos(gamma);
        R(2,3) = cos(gamma).*sin(beta);
        
        R(3,1) = sin(beta).*sin(alpha);
        R(3,2) = -sin(beta).*cos(alpha);
        R(3,3) = cos(beta);
    otherwise
        error(['Unrecognised angle convention ' convention])
end
end



