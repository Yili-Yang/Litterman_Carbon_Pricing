function s=spdiags(V,crange,m,n)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


V=derivH(V);
m=getval(m);
n=getval(n);

s.val=spdiags(V.val,crange,m,n);
s.derivH=spdiags(V.derivH,crange,m,n);

s=class(s,'derivH');
