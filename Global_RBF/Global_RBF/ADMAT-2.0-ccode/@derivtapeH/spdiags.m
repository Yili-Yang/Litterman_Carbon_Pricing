function s=spdiags(V,crange,m,n)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global globp;

s.val=spdiags(getval(V),crange,getval(m),getval(n));

for i=1:globp
    s.deriv(:,:,i) = ...
        full(spdiags(V.deriv(:,:,i),crange,getval(m),getval(n)));
end

s=class(s,'derivtapeH');
