%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  This script computes the Jacobian of Broyden function by ADMAT and 
%  CBroy.m function.
%
%
%                
%               August 2008
%
%    Source code for Example 8.1.1 in Section 8.1 in User's Guide
%
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Set problem size
n = 5;

% Define a deriv input variable
x = ones(n,1);
x = deriv(x, eye(n));

% Compute the Jacobian by CBroy.m function
y = CBroy(x)

% Extract Jacobian matrix from output y
JFD = getydot(y)