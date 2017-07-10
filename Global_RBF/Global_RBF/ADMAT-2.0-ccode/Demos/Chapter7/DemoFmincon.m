%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   This script gives a demo for solving constrained nonlinear minization
%   problem using ADMAT as derivatives estimator, 
%
%       min f(x),   l <= x <= u,
%
%   where f(x) maps R^m to R^1.
%
%                      
%                   September 2008
%
%      Source code for Example 7.2.2 in Section 7.2 in User's Guide
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
% Initialize the random seed
rand('seed',0);
% Initial value of x
x0 = rand(n,1);
% Lower bound of x
l = -ones(n,1);
% Upper bound of x
u = ones(n,1);
% Set the differentiated function by ADMAT
myfun = ADfun('brown',1);

options = optimoptions('fmincon','Algorithm','trust-region-reflective','Hessian','user-supplied','GradObj', 'on');

% Call 'fmincon' to solve the problem with ADMAT as derivatives estimator
[x,FVAL] = fmincon(myfun,x0,[],[],[],[],l,u,[], options)
