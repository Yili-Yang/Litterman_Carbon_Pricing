function s=sparse(i,j,s,m,n)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

i=derivsph(i);
j=derivsph(j);
if nargin == 2
    s=sparse(i.val,j.val);
elseif nargin == 3
    s=derivsph(s);
    s=sparse(i.val,j.val,s.val);
elseif nargin == 4
    m=derivsph(m);
    s=sparse(i.val,j.val,s.val,m.val);
else
    n=derivsph(n);
    s=sparse(i.val,j.val,s.val,m.val,n.val);
end
