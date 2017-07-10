%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  This script computes the sparsity pattern of Jacobian of Broyden 
%  function by ADMAT and CBroySPJ.m function and recover the Jacobian by the
%  forward mode.
%
%
%                
%               August 2012
%
%    Source code for Example 8.1.1 in Section 8.1 in User's Guide
%
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Set problem size
n = 5;
global fdeps;

fdeps = 0.001;

% Define a deriv input variable
x = ones(n,1);
m = length(CBroySPJ(x));

% Compute the Jacobian sparsity pattern of CBroySPJ.m function
SPJ = getjpi('CBroySPJ', m,[], [], 'c')

% Compute the sparse Jacobian from the sparsity pattern
[f, JFD] = evalj('CBroySPJ', x, [],n,SPJ);