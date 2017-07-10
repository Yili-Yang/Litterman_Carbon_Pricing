function L=triu(A,k)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

if nargin ==2
    L.val=triu(A.val,k);
    L.derivS=triu(A.derivS,k);
else
    L.val=triu(A.val);
    L.derivS=triu(A.derivS);
end

L=class(L,'derivS');
