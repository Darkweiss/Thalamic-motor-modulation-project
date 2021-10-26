function [ e ] = myerr(thetas,v,v0)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

R = inv(rotate3deuler(thetas,'xyz'));

tmp = (R*v0-v).^2;
e = sum(tmp(:));
end

