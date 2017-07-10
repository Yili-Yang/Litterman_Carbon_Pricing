function u=solvetri(a,b,c,q)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


global fdeps;

if ~isa(a,'derivH')
    a =derivH(a); 
end
if ~isa(b,'derivH')
    b =derivH(b);
end
if ~isa(c,'derivH')
    c =derivH(c); 
end
if ~isa(q,'derivH')
    q =derivH(q);
end

u.val=solvetri(a.val,b.val,c.val,q.val);

myval=solvetri(a.val+fdeps*a.derivH, b.val+fdeps*b.derivH, ...
    c.val+fdeps*c.derivH,q.val+fdeps*q.derivH);
u.derivH=(myval-u.val)./fdeps;

u=class(u,'derivH');
