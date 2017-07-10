function [Y,Z,D] = nullH( H,tol );
% Detrmine the nullspace for a symmteric matrix H
HH= (H+H')/2;
if nargin < 2
    tol = 10^(-12);
end
[V,D] = eig(HH);
Z = V(:, abs(diag(D))<tol);
[dim,tZ] = size(Z);
Y = V(:, abs(diag(D))>=tol);

end
