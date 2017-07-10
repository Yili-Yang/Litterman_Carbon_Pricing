function y=speye(m,n)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

m1=derivsph(m);
if nargin > 1
    n1=derivsph(n);
else
    n1=m1;
end
y=speye(getval(m1),getval(n1));
y=derivsph(y);

