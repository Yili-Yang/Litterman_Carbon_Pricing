function y=zeros(m,n,p,q)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


m1=getval(m);
if nargin > 1
    n1=getval(n);
end
if nargin > 2
    p1=getval(p);
end
if nargin > 3
    q1=getval(q);
end

if length(m1)==1
    if nargin ==1
        y=zeros(m1);
    elseif nargin==2
        y=zeros(m1,n1);
    elseif nargin==3
        y=zeros(m1,n1,p1);
    else
        y=zeros(m1,n1,p1,q1);
    end
else
    y=zeros(m1);

end

y=deriv(y);
