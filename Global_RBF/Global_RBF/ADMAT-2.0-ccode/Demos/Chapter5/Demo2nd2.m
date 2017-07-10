%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  This script gives a demo to compute the gradient and Hessian of 
%  the Brown function.
%
%                
%               July 2008
%
%    Source code for Example 5.6.2 in Section 5.6 in User's Guide
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% set the problem size
n = 5;
% initial value
x = ones(n,1);
% define a derivtapeH object
x = derivtapeH(x, 1, eye(n));
% call Brown function
y = brown(x);
% get the function value
yval = getval(y)
% get the gradient of y
grad = getydot(y)
% get the Hessian 
H = parsetape(eye(n))
