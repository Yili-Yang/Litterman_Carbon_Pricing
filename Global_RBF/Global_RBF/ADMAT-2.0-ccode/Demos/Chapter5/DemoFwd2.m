%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
%   Compute the Jacobian matrix of Broyden function at x = [1, 1, 1]
%
%                      
%                     July, 2008
%
%       Source code for Example 5.3.3 in Section 5.3 in User's Guide
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
%       Part I: Compute the Jacobian by the forward mode AD
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  create a deriv class object
x = deriv([1,1,1], eye(3));
%  call Broyden functionat x
y = broyden(x)
%
%  get the function value
yval = getval(y)
%  get the Jacobian
J = getydot(y)
%