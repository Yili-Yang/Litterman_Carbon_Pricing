%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  This script gives a demo to compute the first derivative of
%  f(x) = x^2 and y = A*x by the reverse mode AD.
%
%                
%               July 2008
%
%    Source code for Example 5.5.1 and 5.5.2 in Section 5.5 in User's Guide
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% define a derivtape object and record the data on a tape
x = derivtape(3,1);
% compute y = x^2
y = x^2
% get the value of y
yval = getval(y)
% %get the first derivative of y
ydot = parsetape(1)
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
display('Compute the Jacobian of y = A*x by the reverse mode');
% set problem size 
n = 5;      % size of the matrix
rand('seed',0);
% get a random matrix
A = rand(n);
% define a derivtape abd set x as the beginning of the tape
x = derivtape(ones(n,1),1);
% compute y = Ax
y = A * x
% get the value of y
yval = getval(y)
% get the transpose of Jacobian
JT = parsetape(eye(n))