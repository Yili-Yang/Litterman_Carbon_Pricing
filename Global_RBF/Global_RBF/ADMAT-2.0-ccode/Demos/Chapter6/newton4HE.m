function [x, it, nf] = newton4HE(TildeFw, TildeF, BarF, Fun, xstart, tol, itbnd, JPI, hpif, hpiFw)
%
% using Newton step to solve the minimization problem 
%                      min_x f(x)
% where
%         f(x) = BarF(TildeF(x)) + x'*x
% 
% Note that 
%    explicit form of dense Hessian matrix of f(x), H, is not computed, instead
%    we construct a large sparse expanded Hessian matrix H^E.
%
%  INPUT
%     TildeFw-- tildeFEw in expanded system
%     BarF   -- scale-valued function in expanded system
%     xstart -- starting vector
%     tol    -- convergence tolerance
%     itbnd  -- maximum number of iterative steps
%     JPI    -- sparse structure of Jacobian matrix
%     hpif   -- sparse structure of Hessian matrix of BarF
%     hpiFw  -- sparse structure of Hessian matrix of TildeFw
%
%  OUTPUT
%     x  -- solution from Expanded Newton method
%     it -- number of iteratives
%     nf -- value of function


if (nargin < 4) tol = 1e-05; end
if (nargin < 5) itbnd = 60; end
n = length(xstart);
x = xstart;
I = sparse(eye(n));
it = 0;
gradx = ones(n,1);
myfun = ADfun(Fun, 1);
%
%  Main loops of Newton steps
while (norm(gradx) > tol & it < itbnd)  
    %
    % compute y and FEx, FEy = I
    %
    [y, FEx] = evalj(TildeF, x, [], [], JPI);
    % 
    Extra.y = x;
    [z, grady, H2] = evalH(BarF, y, Extra, hpif);
    % solve for w : (FEy)' w = - grady
    w = -grady(:);
    % construct HE
    HE(1:n, n+1: 3*n) = [I, -FEx];
    HE(n+1:3*n, 1:n) = [I; -FEx'];
 
    % compute function value, gradient and Hessian of 'TildeFw'.
    
    Extra.w = w;
    Extra.y = y;
    [z, grad, Ht] = evalH(TildeFw,  x, Extra, hpiFw);
    %
    % construct HE
    HE(n+1:2*n, n+1:2*n) = H2;
    HE(2*n+1:3*n, 2*n+1:3*n) = Ht+2*I;
    %
    % solve HE*d = [0, 0, gradx];
    %
    Extra.n = n;
    [nf , gradx] = feval(myfun, x, Extra);
    HE = sparse(HE);
    d = -HE \ [zeros(2*n,1); gradx(:)];
    % update w, y, x
    x = x + d(2*n+1:3*n);
    it  = it + 1;
end
nf = feval(myfun,x, Extra);
