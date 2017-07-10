%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  This script gives a demo to compute the first derivative of
%  f(x) = x^2 and y = A*x by the forward mode AD.
%
%                
%               July 2008
%
%    Source code for Example 5.3.1 and 5.3.2 in Section 5.3 in User's Guide
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
%        Compute the 1st order derivative of f(x) = x^2
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% define a deriv class object with value 3 and derivative 1
x = deriv(3,1)
% compute y = x^2
y = x^2

% get the value of y = x^2
yval = getval(y)
% get the first order derivative of y = x^2
ydot = getydot(y)
%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
%        Compute the 1st order derivative of y = A*x
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
display('Compute the Jacobian of y = A*x by the forward mode');
% set the problem size
n = 5;
% initialize the random seed
rand('seed',0);
%
% set a 5-by-5 random matrix
A = rand(n);
% set x to be an all one vector
x = ones(n,1);
% define a deriv class object x with value ones(n,1) and 
% derivative an identity matrix
x = deriv(x, eye(n));
% compute y = A*x
y = A * x

% get value of y = A*x
yval = getval(y)
% get 1st order derivative of y
ydot = getydot(y)

