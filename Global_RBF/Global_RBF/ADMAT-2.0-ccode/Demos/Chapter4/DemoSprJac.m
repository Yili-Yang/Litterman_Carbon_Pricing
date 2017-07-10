%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  This script gives a demo to compute the Jacobian of the arrowfun function
%  by the efficient sparse Jacobian computation
%
%                  
%                 July 2008
%
%    Source code for Example 4.1.1 in Section 4.1 in User's Guide
%
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% set problem size
n = 5;
% Initialize x
x = ones(n,1);
m = length(arrowfun(x));
% Compute "JPI", the sparsity pattern, corresponding to function arrowfun
JPI = getjpi('arrowfun', m);
% Compute the function value and Jacobian of arrowfun
[F, J] = evalj('arrowfun', x, [], n, JPI)