%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
%   Compute the Jacobian matrix of Broyden function at x = [1, 1, 1]
%   by the reverse mode.
%
%                      
%                     July, 2008
%
%       Source code for Example 5.5.3 in Section 5.5 in User's Guide
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
% create a derivtape object and set x to the beginning of the tape
x = derivtape([1,1,1], 1);
% call the broyden function
y = broyden(x);
% get the value of y
yval = getval(y)
% compute the J^T
JT = parsetape(eye(3))