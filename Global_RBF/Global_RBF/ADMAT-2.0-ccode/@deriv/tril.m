function L=tril(A,k)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

if nargin ==2
    L.val=tril(A.val,k);
    L.deriv=tril(A.deriv,k);
else
    L.val=tril(A.val);
    L.deriv=tril(A.deriv);
end
L=class(L,'deriv');
