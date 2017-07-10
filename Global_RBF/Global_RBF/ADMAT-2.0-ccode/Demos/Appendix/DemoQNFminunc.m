%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   This script gives a demo for solving unconstrained nonlinear minization
%   problem using ADMAT as derivatives estimator by 'fminunc'
%
%                        min f(x),   
%
%   where f(x) maps R^m to R^1. In this demo, Quasi-Newton in 'fminunc' is
%   triggered with ADMAT computing gradients
%
%                     
%                   Oct. 2008
%
%      Source code for Example A.1.1 in Appendix in User's Guide
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
% Set problem size
n = 5;
% Initialize the random seed
rand('seed',0);
% Initializex
x0 = rand(n,1)
% Set the differentiated function by ADMAT
myfun = ADfun('brown',1);
% Get the default vaule of argument 'options' 
options = optimset('fminunc');
%
% Turn on the gradient flag of input argument 'options'. Thus, the
% solver uses user specified method to compute gradient (ADMAT).
options = optimset(options, 'GradObj', 'on');
% Set the flag of 'LargeScale' off, so that the Quasi-Newton method will be
% used.
options = optimset(options, 'LargeScale', 'off');
% Solve the constrained nonlinear minimization by 'fmincon' with ADMAT
% estimating gradients only.
[x,FVAL] = fminunc(myfun,x0, options)