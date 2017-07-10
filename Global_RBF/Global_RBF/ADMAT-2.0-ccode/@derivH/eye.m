function y=eye(m,n)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


m1=getval(m);
if nargin > 1
    n1=getval(n);
else
    n1=m1;
end
y=eye(m1,n1);

y=derivH(y);
