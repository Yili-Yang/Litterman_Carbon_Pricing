function y=ones(m,n)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

m1=getval(m);
if nargin > 1 
    n1=getval(n); 
end
if length(m1) == 2 
    n1 = m1(2); 
    m1=m1(1);
end
y=ones(m1,n1);
y=derivS(y);

