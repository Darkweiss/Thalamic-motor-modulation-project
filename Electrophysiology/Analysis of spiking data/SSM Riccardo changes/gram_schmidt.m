%use this to obtain orthonormal basis for eigenposes
function[Y] = gram_schmidt(X)
%example:
%X = randn(10,20);
%X = X-repmat(mean(X')',1,20);
[Nx,Ny] = size(X);
Y = zeros(Nx,Ny);
for n = 1:Nx
    Y(n,:) = X(n,:);
    for m = 1:n-1
        proj = (Y(m,:)*X(n,:)')/(Y(m,:)*Y(m,:)');
        Y(n,:) = Y(n,:) - proj*Y(m,:);
    end
end
for n = 1:Nx
    Y(n,:) = Y(n,:)/norm(Y(n,:),2);
end