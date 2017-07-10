function s=sparse(i,j,s,m,n)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

if nargin == 2
    s=sparse(getval(i),getval(j));
elseif nargin == 3
    s=sparse(getval(i),getval(j),getval(s));
elseif nargin == 4
    s=sparse(getval(i),getval(j),getval(s),getval(m));
else
    s=sparse(getval(i),getval(j),getval(s),getval(m),getval(n));
end

s=derivtapeH(s,0);
