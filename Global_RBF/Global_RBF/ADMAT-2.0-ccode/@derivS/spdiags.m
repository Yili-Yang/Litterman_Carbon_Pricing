function s=spdiags(V,crange,m,n)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

V=derivS(V);
m=getval(m);
n=getval(n);
s.val=spdiags(V.val,crange,m,n);
s.derivS=spdiags(V.derivS,crange,m,n);

s=class(s,'derivS');
