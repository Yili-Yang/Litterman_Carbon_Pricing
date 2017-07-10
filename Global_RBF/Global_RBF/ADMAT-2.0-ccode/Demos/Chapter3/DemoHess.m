%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
%   Compute the gradient and Hessian of Brown function at x = [1, 1, 1, 1,1]
%   by feval.
%
%                      
%                     July, 2008
%
%       Source code for Example 3.3.1 in Section 3.3 in User's Guide
%
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.          *
%       ******************************************************************

%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  set the differential function to be 'brown'. It is a must before 
%  calling feval to  compute differentiation. Since 'brown' is a
%  mapping from R^n to R, the second argument in 'ADfun' is set to 1.
%
% Set the function to be the Brown function 
myfun = ADfun('brown', 1);
%  set problem size
n = 5;
%  set independent variable to an all one vector
x = ones(n,1);
%
%  call feval to get the function value, gradient and Hessian
%  without argument "options"
%
display('Compute the function value, gradient and H, Hessian of Brown function at x');
[v, grad, H] = feval(myfun, x)
%
%  compute HV by feval with argument "otptions"
%
% set up the argument option to compute HV and V
%
display('Compute the product of H*V only'); 
options = setopt('htimesv', ones(n,3));
HV= feval(myfun, x, [], options)



