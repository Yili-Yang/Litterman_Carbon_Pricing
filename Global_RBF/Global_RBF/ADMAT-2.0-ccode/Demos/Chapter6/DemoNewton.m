%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
%   Solve the nonlinear equation arrowfun(x) = 0 by Newton mehod 
%
%                     
%                     July, 2008
%
%       Source code for Example 6.1.1 in Section 6.1 in User's Guide
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% set problem size
n = 5;
% initialize the random seed
rand('seed',0);
% set a starting point
x = rand(n,1)
% solve the nonlinear equation
[x, normy, it] = newton('arrowfun', x, 1e-8, 50)
