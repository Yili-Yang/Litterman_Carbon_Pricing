%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   This script gives a demo for solving unconstrained nonlinear minization
%   problem using ADMAT as derivatives estimator by 'fminunc'
%
%                        min f(x),   
%
%   where f(x) maps R^m to R^1. In this demo, the problem is solved
%   twice. The first time, ADMAT estimates gradients only, but Hessians are
%   estimated by the default finite difference method. The second time,
%   ADMAT estimates both gradients and Hessians.
%
%                      
%                   September 2008
%
%      Source code for Example 7.2.1 in Section 7.2 in User's Guide
%
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Problem size
n = 5;
% initialize the random seed
rand('seed', 0);
% Initial value of x
x0 = rand(n,1);
% Set the differentiated function by ADMAT
myfun = ADfun('brown',1);
% Get the default vaule of argument 'options' 
options = optimset('fmincon');
%
%     Solve the problem first time
%
% Only turn on the gradient flag of input argument 'options'. Thus, the
% solver uses user specified method to compute gradient (ADMAT), but
% estimate Hessians by finite difference method.
display('solve the problem with computing gradient by AD ONLY'); 
options = optimset(options, 'GradObj', 'on');
options = optimset(options, 'LargeScale', 'off');
% Solve the constrained nonlinear minimization by 'fmincon' with ADMAT
% estimating gradients only.
[x,FVAL] = fminunc(myfun,x0, options)
%
%     Sove the problem second time
%
% Turn on the gradient flags of input argument 'options'. Thus, the
% solver uses user specified method to compute both gradient and Hessians
display('solve the problem with computing gradients and Hessians by AD'); 
options = optimset(options, 'GradObj', 'on');
options = optimset(options, 'Hessian', 'on');
% Call 'fmincon' to solve the problem with ADMAT as derivatives estimator
[x,FVAL] = fminunc(myfun,x0,options)
