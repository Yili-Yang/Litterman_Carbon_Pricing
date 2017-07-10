function L=triu(A,k)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

if nargin ==2
    L.val=triu(A.val,k);
    L.deriv=triu(A.deriv,k);
else
    L.val=triu(A.val);
    L.deriv=triu(A.deriv);
end
L=class(L,'deriv');
