clear all; clc;
startup;

n = 20;
rand('seed', 0);
x = randn(n,1);
mu = randn(n,1);
mu = mu / sum(mu);

Extra.mu = mu;
Extra.n = n;

myfun = ADfun('mean_feval', 1);
options = setgradopt('revprod',n);
[frev, grev] = feval(myfun, x, Extra,options)

myfun = ADfun('mean_feval', 1);
options = setgradopt('forwprod',n);
[ffor, gfor] = feval(myfun, x, Extra,options)

%% ========================================================================

clear all;
startup;

M = 10;
[x,uT,A,b0] = prepareTestCase(M);

x = randn(4*M,1);

Extra.B = inv(A);
Extra.M = M;
Extra.uT = uT;

n = 4*M;

myfun = ADfun('DirichletfunValue', 1);
options = setgradopt('revprod',n);
[frev, grev] = feval(myfun, x, Extra,options)

% myfun = ADfun('DirichletfunValue', 1);
% options = setgradopt('forwprod',n);
% [ffor, gfor] = feval(myfun, x, Extra,options)
