function y=zeros(m,n,p)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

m1=getval(m);
if nargin == 2  
    n1=getval(n);
    y = zeros(m1,n1);
elseif    nargin == 3
     n1=getval(n);
    p1 = getval(p); 
    y = zeros(m1,n1,p1);
end
if length(m1) == 2 
    n1 = m1(2);
    m1 = m1(1); 
    y = zeros(m1,n1);
end


y=derivtapeH(y,0);
