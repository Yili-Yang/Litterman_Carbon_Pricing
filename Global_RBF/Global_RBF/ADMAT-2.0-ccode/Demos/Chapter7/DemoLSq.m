%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%    This script gives a demo for using ADMAT with MATLAB nonlinear 
%    least square with box constraints, i.e,
%
%         min ||F(x)||^2,  s.t. l <= x <= u,
%     where F(x) maps R^m to R^n.
%
%                     
%                 September 2008
%    Source code for Example 7.1.1 in Section 7.1 in User's Guide
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
n = 5;
% initialize the random seed
rand('seed', 0);
% initial value of x
x0 = rand(n,1)
% lower bound of x
l = -ones(n,1);
% upper bound of x
u = ones(n,1);
% get the default value of MATLAB 'lsqnonlin' solver
options = optimset('lsqnonlin');
% Turn on the Jacobian flag in 'options'
options = optimset(options,'Jacobian', 'on');
% Set the function to be differentiated by ADMAT
myfun = ADfun('broyden', n);
% Call 'lsqnonlin' to solve the problem with using ADMAT to compute
% derivatives
[x, RNORM] = lsqnonlin(myfun, x0,l,u, options)
