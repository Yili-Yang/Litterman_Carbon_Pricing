function s=sparse(i,j,s,m,n)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


i=getval(i);
j=getval(j);
if nargin == 2
    s=sparse(i,j);
elseif nargin == 3
    s=getval(s);
    s=sparse(i,j,s);
elseif nargin == 4
    m=getval(m);
    s=sparse(i,j,s,m);
else
    n=getval(n);
    s=sparse(i,j,s,m,n);
end

s=derivH(s);
