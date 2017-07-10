function y=sparse(i,j,s,m,n)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

i=getval(i);
if nargin == 1
    y=sparse(i);
    y=derivS(y);
elseif nargin == 2
    j=getval(j);
    y=sparse(i,j);
    y=derivS(y);
elseif nargin == 3
    j=getval(j);
    s=derivS(s);
    y.val=sparse(i,j,s.val);
    y.derivS=sparse(i,j,s.derivS,m,n);
    y=class(y,'derivS');
elseif nargin == 4
    j=getval(j);
    m=getval(m);
    s=derivS(s);
    y.val=sparse(i,j,s,m);
    y.derivS=sparse(i,j,s.derivS,m,n);
    y=class(y,'derivS');
else
    j=getval(j);
    m=getval(m);
    n=getval(n);
    s=derivS(s);
    y.val=sparse(i,j,s.val,m,n);
    y.derivS=sparse(i,j,s.derivS,m,n);
    y=class(y,'derivS');
end
