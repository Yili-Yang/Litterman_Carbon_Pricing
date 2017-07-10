function y=speye(m,n)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

if isa(m, 'derivtape')
    m1 = m.val;
else
    m1 = m;
end

if nargin > 1
    if isa(n, 'derivtape')
        n1 = n.val;
    else
        n1 = n;
    end
else
    n1=m1;
end
y=speye(m1, n1);
y=derivtape(y);
