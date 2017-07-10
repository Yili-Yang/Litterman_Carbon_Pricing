%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                             ADMAT-2.0 (Professional version) 
%                 (Automatic Differentiation Toolbox in Matlab)
%
% A new version of ADMAT, which provides a more stable and efficient 
% AD computation than the previous version. This release is a professional
% version of ADMAT-2.0. 
%
%  If you discover a bug in the package, please contact
%  cra@cayugaresearch.com.
%      
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Documentation
%  
%    User's Guide  -- User guide for ADMAT 2.0
%
%
%  Forward mode
%
%   @deriv   --  class of overloaded functions for computing the first 
%                derivatives in forward mode. The derivative has one 
%                more dimension than the input variable.
%   @derivS  --  class of overloaded functions for computing the first 
%                derivatives in forward mode. The derivative has the same
%                size as the input variable.
%
%  Reverse mode
%
%   @derivtape -- class of overloaded functions, which record all the
%                 operations on a tape.
%   reverse    -- parse the tape from the end and get the first derivatives
%                 in reverse mode. The derivative has one more dimension 
%                 than the input variable.
%   reverses  --  parse the tape from the end and get the first derivatives
%                 in reverse mode. The derivative has the same size as the 
%                 input variable.
%
%  Sparsity of the Jacobian matrix
%
%   @derivspj  -- class of overloaded functions, which compute the sparsity of
%                 the Jacobian matrix in forward mode.
%
%  Sparse Jacobian computation
%
%   admit -- compute the sparse Jacobian matrix based on the sparseity structure
%
%  Newton method
%
%   Newton -- Standard Newton method and fast structured Newton method
%
%  Interpolation
%   
%   Interpolation -- 1-D interpolation with first order derivative, which has 
%                   the same interface with original Matlab interp1.m, but the 
%                   function of 1-D interpolation in ADMAT 2.0 is interp1_d.m
%
