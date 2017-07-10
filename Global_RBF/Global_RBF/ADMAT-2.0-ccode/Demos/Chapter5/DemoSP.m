%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
%   Compute sparsity patterns of Jacobian and Heesian by jacsp and hesssp.
%
%                      
%                     July, 2008
%
%       Source code for Example 5.1.1 and 5.1.2 in Section 5.1 in User's Guide
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%         Compute the sparsity pattern of Jacobian of Broyden
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% set the problem size
n = 5;
% compute the sparsity pattern of Jacobian of Broyden function
SPJ = jacsp('broyden', n, n)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%          Compute the sparsity pattern of Hessian of Brown
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% set the problem size
n = 5;
% compute the sparsity pattern of Hessian of brown function
SPH = hesssp('brown', n)

