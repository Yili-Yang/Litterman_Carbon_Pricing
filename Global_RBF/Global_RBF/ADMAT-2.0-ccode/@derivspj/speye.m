function y=speye(m,n)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

m1=derivspj(m);
if nargin > 1
    n1=derivspj(n);
else
    n1=m1;
end
y=speye(m1.val,n1.val);
y=derivspj(y);

