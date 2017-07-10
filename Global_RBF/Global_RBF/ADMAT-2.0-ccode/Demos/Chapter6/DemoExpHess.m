%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%    sample code of one step of structure Newton computation for solving 
%    a minimization problem,
%
%                 F(x) = barF(tildeF(x)) + x'*x.
%
%    Source code of Example 6.2.3 in Section 6.2 in User's guide.
%
%                   
%                  Otc. 2008
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% problem size
n = 25;
I = eye(n);

% assign TildeF, TildeFw and BarF
TildeF = 'broyden';
TildeFw = 'tildeFw';
BarF = 'barF';

% initialize x and values in Extra
x = rand(n,1);
Extra.w = ones(n,1);
Extra.y = ones(n,1);
Extra.n = n;
m = length(broyden(x));

% compute the sparsities of Jacobian and Hessians 
JPI = getjpi(TildeF, m);
hpif = gethpi(BarF, n, Extra);
hpiFw = gethpi(TildeFw, n,Extra);
%
% One step of structured Newton computation
%
% compute y and FEx, FEy = I
%
[y, FEx] = evalj(TildeF, x, [], [], JPI);
% Compute gradient and Hessian of barF
Extra.y = x;
[z, grady, H2] = evalh(BarF, y, Extra, hpif);
% assign w, which is equal to -grady(:)
Extra.w = -grady(:);
% compute function value, gradient and Hessian of 'TildeFw'.
Extra.y = y;
[z, grad, Ht] = evalh(TildeFw,  x, Extra, hpiFw);

% construct HE
HE = zeros(3*n);
HE(1:n, n+1: 3*n) = [I, -FEx];
HE(n+1:3*n, 1:n) = [I; -FEx'];
HE(n+1:2*n, n+1:2*n) = H2;
HE(2*n+1:3*n, 2*n+1:3*n) = Ht+2*I;
%
% solve HE*d = [0, 0, gradx] and update x
%
Extra.n = n;
myfun = ADfun('OptmFun', 1);
[nf , gradx] = feval(myfun, x, Extra);
HE = sparse(HE);
d = -HE \ [zeros(2*n,1); gradx(:)];
x = x + d(2*n+1:3*n);