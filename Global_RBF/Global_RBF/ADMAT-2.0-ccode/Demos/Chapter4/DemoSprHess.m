%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  This script gives a demo to compute the gradient and Hessian of the
%  Brown function by the efficient sparse Hessian computation
%
%                  
%                 July 2008
%
%    Source code for Example 4.2.1 in Section 4.2 in User's Guide
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
% set independent variable
x = ones(n,1);
% COmpute relevant sparsity information encapsulated in "HPI"
HPI = gethpi('brown', n);
% Compute the function value, gradient and Hessian of brown
[v, grad, H] = evalh('brown', x, [], HPI)