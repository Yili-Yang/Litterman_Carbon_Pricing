function C = Cmult(A, B)
% C = Cmult(A, B)
%
% compute matrix product of A and B by C subrountine, mexmult.c
%
% This gives an example how to use finite difference method to add
% existing C subroutine into AMDAT package.
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

if (isa(A, 'deriv') && ~isa(B, 'deriv'))      % A is an objective of deriv
                                              % class, but B is not
    val = getval(A);    % get the value of A
    drv = getydot(A);   % get the derivative part of A
    C = mexmult(val,B);   % compute the product of A and B
    [m, n] = size(C);
    Cdot = zeros(m,n,globp);  % initialize the gradiant of C
    % compute the derivtive by finite difference method
    for i = 1 : globp
        tmp = mexmult(val + fdeps*drv(:,:,i), B);
        Cdot(:,:,i) = (tmp - C)/fdeps;
    end
    % set C as an objective of deriv class
    C =deriv(C, Cdot);
    
elseif (~isa(A, 'deriv') && isa(B, 'deriv'))      % B is an objective of deriv
                                                  % class, but A is not
    val = getval(B);    % get the value of B
    drv = getydot(B);   % get the derivative part of B
    C = mexmult(A,val);   % compute the product of A and B
    [m, n] = size(C);
    Cdot = zeros(m,n,globp);  % initialize the gradiant of C
    % compute the derivtive by finite difference method
    for i = 1 : globp
        tmp = mexmult(A, val + fdeps*drv(:,:,i));
        Cdot(:,:,i) = (tmp - C)/fdeps;
    end
    % set C as an objective of deriv class
    C =deriv(C, Cdot);
    
elseif (isa(A, 'deriv') && isa(B, 'deriv'))     % both A and B are deriv
                                                 % class objective
    valA = getval(A);    % get the value of A
    drvA = getydot(A);   % get the derivative part of A
    valB = getval(B);    % get the value of B
    drvB = getydot(B);   % get the derivative part of B
    C = mexmult(valA, valB);   % compute the product of A and B
    [m, n] = size(C);
    Cdot = zeros(m,n,globp);  % initialize the gradiant of C
    
    % compute the derivtive by finite difference method
    for i = 1 : globp
        tmp = mexmult(valA, valB + fdeps*drvB(:,:,i));
        Cdot(:,:,i) = (tmp - C)/fdeps;
    end
    for i = 1 : globp
        tmp = mexmult(valA + fdeps*drvA(:,:,i), valB);
        Cdot(:,:,i) = Cdot(:,:,i) + (tmp - C)/fdeps;
    end
    % set C as an objective of deriv class
    C =deriv(C, Cdot);
else                         % neither A nor B is deriv class objective
    
    C = mexmult(A,B);                                                
end


        
