%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%    Compare the performance of computing a gradient
%    by straightfoward forward mode, reverse mode, and sparse blocks
%    method.  The testing problem is as follows.
%
%    Eular method to solve the ODE
%           y' = F(y),
%    in the structured form metioned in Section 5.
%    Define a function z = f(x), that is
%        y0 = x
%        y_i = y_{i-1} + h*F(y_{i-1}}
%        z = || y_p - yT ||_1,
%    where i = 1....p. Its gradient is
%        g = g_f0 * J_p * ....* J_1 * J_0
%    
%  
%                 
%              August 2008
%   Source code for Example 5.2.1 in Section 5.2 in User's Guide
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% problem size
n = 80;
% number of Eular steps
Extra.p = 10;
np = 10;
nk = 5;
% function F on the right hand side of ODE
Extra.fun = 'broyden';
% Eular method step size
Extra.h = 0.0001;
% initial values x
x = rand(n,1);
% desired final state yT
Extra.yT = rand(n,1);
tRvs = zeros(nk,1);
tFwd = zeros(nk,1);
tSpr = zeros(nk,1);
tFun = zeros(nk,1);
for k = 1 : nk
    Extra.p = np*k;
    %------------------------------------------------------------------------
    %
    %  compute the gradient of f(x) by the straightforward reverse mode
    %
    myfun = ADfun('strctEular',1);
    t = cputime;
    options = setopt('revprod', 1);
    [f, gRvs] = feval(myfun, x, Extra, options);
    tRvs(k) = cputime - t;
    fprintf('Running time of the straghtfoward reverse mode: %e.\n', tRvs(k));
    %
    %-----------------------------------------------------------------------
    %
    %-----------------------------------------------------------------------
    %
    %  compute the gradient of f(x) by the forward mode
    %
    %-----------------------------------------------------------------------
    cleanup
    t = cputime;
    options = setopt('forwprod', (eye(n)));
    [f, gFwd] = feval(myfun, x, Extra, options);
    tFwd(k) = cputime - t;
    fprintf('Running time of the straghtfoward forward mode: %e.\n', tFwd(k));
    %
    %-----------------------------------------------------------------------
    %
    %  compute the gradient of f(x) exploiting the sprasity
    %
    %
    % compute the sparsity of function S 
    t = cputime;
    m = length(funcS(x, Extra));
    JPI = getjpi('funcS', m, n, Extra);
    % evaluate J1, J2, ...., Jp with the same sparsity.
    J = sparse(eye(n));
    y = x;
    for i = 1 : Extra.p
        [y, J1] = evalj('funcS', y, Extra, n, JPI);
        J = J1*J;
    end
    % compute the gradient of function f0
    myfun = ADfun('funcF0',1);
    options = setopt('revprod', 1);
    [f, gSpr] = feval(myfun, y, Extra, options);
    gSpr = gSpr*J;
    tSpr(k) = cputime - t;
    fprintf('Running time by exploiting sparsities: %e.\n', tSpr(k));
    %
    % function evaluation time
    %
    t = cputime;
    y0 = x;
    for i = 1 : Extra.p
        y1 = y0+Extra.h*feval(Extra.fun, y0);
        y0 = y1;
    end
    % compute the gradient of f0, g_f0
    z = sum(abs(y1-Extra.yT));
    tFun(k) = cputime - t;
    fprintf('------------------------------------------\n');
end