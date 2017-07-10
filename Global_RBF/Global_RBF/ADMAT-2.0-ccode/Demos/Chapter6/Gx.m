% function G(x) of expanded Newton process
%
%      y' = F(x),
%      y(1) = phix(u0).
% 
% where phix is a power operation
% 
% G(x) = y - phix(u0)
%
function fval = Gx(y, Extra)

global n;

u0 = Extra.u0;
phi = Extra.phi;
p = Extra.M;    % number of intermediate variables, y1,...,yN
n = Extra.N;     % size of original problem.

fval = y(p*n+1 : (p+1)*n) - feval(phi, u0);

