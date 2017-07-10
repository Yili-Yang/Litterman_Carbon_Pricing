%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   This script analyze the sensitivity of the minimization 
%   problem,
%
%         min brownv(x,V),
%
%   using ADMAT.
%
%   Source code of Example A.2.1 in Appendix of the User's Guide
%
%                 
%               Oct. 2008
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% set the problem size
n = 5;
% set the initial value of x
x0 = 0.1*rand(n,1);
% set the initial value of V
V = 0.5;
%
%  Solve the unconstrained minimization problem with MATLAB solver 
%  'fminunc' using ADMAT as a derivatives estimator.
options = optimset('fminunc');
myfun = ADfun('brownv', 1);
options = optimset(options, 'GradObj', 'on');
options = optimset(options, 'Hessian', 'on');
[x1, FVAL1] = fminunc(myfun, x0, options, V);
%
% Set V to a deriv class objective
V = deriv(V, 1);
% Compute the sensitivity of brownv of V at the optimal point x1
f = brownv(x1, V);
sen = getydot(f)