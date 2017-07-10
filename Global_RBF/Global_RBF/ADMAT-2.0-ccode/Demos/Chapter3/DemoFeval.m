%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  This script gives a demo to compute the gradient of a weighted
%  mean function. The weighted mean function is defined in MATLAB
%  function mean_feval.m
%
%
%                
%               August 2008
%
%    Source code for Example 3.1.2 in Section 3.1 in User's Guide
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
%  Set problem size
n = 5;
%  Initialize the random seed
rand('seed',0);
%  Define a vector x
x = rand(n,1);
%  Define a weight vector
mu = rand(n,1)
mu = mu/sum(mu)
%  Assign mu and n to Extra
Extra.mu = mu;
Extra.n = n;
%  Set the function to be differentiated to mean_feval
myfun = ADfun('mean_feval',1);
%  Compute the gradient
[f, grad] = feval(myfun, x, Extra)