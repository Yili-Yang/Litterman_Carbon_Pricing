function s=spdiags(V,crange,m,n)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


global globp;

V=deriv(V);
m=getval(m);
n=getval(n);
s.val=spdiags(V.val,crange,m,n);
if globp> 1
    for i=1:globp
        s.deriv(:,:,i)=full(spdiags(V.deriv(:,:,i),crange,m,n));
    end
else
    s.deriv=spdiags(V.deriv,crange,m,n);
end
s=class(s,'deriv');
