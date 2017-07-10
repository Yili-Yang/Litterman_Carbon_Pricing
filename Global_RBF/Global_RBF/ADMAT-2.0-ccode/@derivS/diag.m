function out=diag(V,k)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

V=derivS(V);


if nargin==1
    out.val=diag(V.val);
    out.derivS=diag(V.derivS);
else
    k=getval(k);
    out.val=diag(V.val,k);
    out.derivS=diag(V.derivS,k);
end

out=class(out,'derivS');
