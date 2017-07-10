%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  This script gives a demo to compute the first and second order
%  derivative of f(x) = x^2.
%
%                
%               July 2008
%
%    Source code for Example 5.6.1 in Section 5.6 in User's Guide
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% define a derivtapeH object with value 3
x = derivtapeH(3,1,1);
% compute y = x^2
y = x^2;
% get the value of y
yval = getval(y)
% get the first order derivative of y
y1d = getydot(y)
% get the second order derivative of y
y2d = parsetape(1)

