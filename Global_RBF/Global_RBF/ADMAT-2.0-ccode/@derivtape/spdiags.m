function sout=spdiags(V,crange,m,n)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global varcounter;

V=derivtape(V);
if isa(m, 'derivtape')
    m = m.val;
end

if isa(n, 'derivtape')
    n = n.val;
end
% m=derivtape(m);
% n=derivtape(n);
sout.val=spdiags(V.val,crange,m,n);

sout.varcount=varcounter;
sout=class(sout,'derivtape');
savetape('spdiags',sout,V.varcount,crange);
