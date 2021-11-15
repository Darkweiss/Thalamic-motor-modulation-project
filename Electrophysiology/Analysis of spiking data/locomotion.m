function [locomotion_coeff] = locomotion(all_coeffs)
%LOCOMOTION Outputs a locomotion coefficient
%   Input: 3D position of body landmarks
%   Output: Locomotion coefficient
centroid = zeros(numel(all_coeffs(:,1)),3);
centroid(:,1) = all_coeffs(:,1);
centroid(:,2) = all_coeffs(:,2);
centroid(:,3) = all_coeffs(:,3);

locomotion_coeff = distance_calc(centroid);


function  d3 = distance_calc(xyz)
% distance between xyz coords in successive frames

Nframes = size(xyz,1);
d3 = zeros(Nframes,1);
for i = 1:Nframes-1
    v1 = xyz(i,:);
    v2 = xyz(i+1,:);
    if sum(isnan([v1 v2]))==0
        d = v2-v1;
        d3(i) = sqrt(sum(d.^2,2));
    else
        d3(i) = nan;
    end
end
d3(i+1) = 0;
clear i v1 v2 d
end
end

