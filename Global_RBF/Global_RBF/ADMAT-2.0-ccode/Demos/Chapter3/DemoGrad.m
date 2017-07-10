%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
%   Compute the Jacobian matrix of Brown function at x = [1, 1, 1, 1, 1]
%
%                      
%                     August, 2008
%
%       Source code for Example 3.1.1 in Section 3.1 in User's Guide
%
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Set the differentiable function to be Brown function
myfun = ADfun('brown',1);
%  Set the dimension of x
n = 5;
% Initialize vector x
%  Define x to be an all one vector
x = ones(n,1);
display('Compute gradient of a Brown function.');
%  Compute the gradient of Brown function
[f, grad] = feval(myfun, x)
%  Compute the gradient by the forward mode
%
% set options forward mode AD. Input n is the problem size
display('Compute gradient of a Brown function by the forward mode.');
options = setgradopt('forwprod', n);
% compute gradient
[f, grad] = feval(myfun, x, [], options)

%  Compute the gradient by the reverse mode
%
% set options to reverse mode AD. Input n is the problem size
display('Compute gradient of a Brown function by the reverse mode.');
options = setgradopt('revprod', n);     
% compute gradient
[f, grad] = feval(myfun, x, [], options)  