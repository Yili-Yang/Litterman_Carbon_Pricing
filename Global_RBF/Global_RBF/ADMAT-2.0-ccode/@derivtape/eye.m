function y = eye(m,n)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

m1=derivtape(m);
if nargin > 1
    n1=derivtape(n);
else
    n1=m1;
end

y=eye(m1.val,n1.val);

y=derivtape(y);
