function y = CBrown(x, Extra)
% y = CBrown(x, Extra)
%
% compute Brown function at x by C subroutine, mexbrown.c
% Mapping,   CBrown: R^n ---> R
%
% This gives an example how to use finite difference method to add
% existing C subroutine into AMDAT package. Users can call this function
% as any functions in ADMAT.
%
% NOTE: COMPATIBLE ONLY TO FORWAD MODE IN AMDAT.
%
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

%
global globp;
global fdeps;

if isa(x, 'deriv')      % x is an objective of deriv class
    val = getval(x);    % get the value of x
    drv = getydot(x);   % get the derivative part of x
    y = mexbrown(val);   % compute the function value at x
    ydot = zeros(1,globp);  % initialize the gradiant of y
    % compute the derivtive by finite difference method
    for i = 1 : globp
        tmp = mexbrown(val + fdeps*drv(:,i));
        ydot(:,i) = (tmp - y)/fdeps;
    end
    % set y as an objective of deriv class
    y =deriv(y, ydot);
else
    y = mexbrown(x);
end


        
