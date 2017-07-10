function y = CBroy(x, Extra)
% y = CBroy(x, Extra)
%
% compute the broy function at x by C subrountine, mexbroy.c
%    Mapping,   CBoy : R^n ----> R^n 
%
%
% INPUT:
%       x - The current point (column vector). When it is an
%           object of deriv class, the fundamental operations
%           will be overloaded automatically.
%   Extra - Parameters required in CBroy.
%     
%
% OUTPUT:
%  y -    The function value at x. When x  is an object
%         of deriv class, fvec will be an object of deriv class 
%         as well. There are two fields in fvec. One is the 
%         function value at x, the other is the gradient at x.
%
%
% This gives an example how to use the finite difference method to add
% existing C subroutine into AMDAT package. Users can call this function
% as any functions in ADMAT.
%
% NOTE: COMPATIBLE ONLY TO FORWAD MODE IN AMDAT.
%
%
%    Source code for Example 8.1.1 in Section 8.1 in User's Guide

%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

%
global globp;
global fdeps;

n = length(x);
if isa(x, 'deriv')      % x is an objective of deriv class
    val = getval(x);    % get the value of x
    drv = getydot(x);   % get the derivative part of x
    y = mexbroy(val);   % compute the function value at x
    ydot = zeros(getval(n),globp);  % initialize the derivative of y
    % compute the derivtive by finite difference method
    for i = 1 : globp
        tmp = mexbroy(val + fdeps*drv(:,i));
        ydot(:,i) = (tmp - y)/fdeps;
    end
    % set y as an objective of deriv class
    y =deriv(y, ydot);
else
    y = mexbroy(x);
end


        
