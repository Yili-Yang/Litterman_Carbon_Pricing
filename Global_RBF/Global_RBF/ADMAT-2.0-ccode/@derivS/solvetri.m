function u=solvetri(a,b,c,q)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global fdeps;
if ~isa(a,'derivS') 
    a =derivS(a);
end
if ~isa(b,'derivS')
    b =derivS(b);
end
if ~isa(c,'derivS')
    c =derivS(c); 
end
if ~isa(q,'derivS') 
    q =derivS(q); 
end

u.val = solvetri(a.val,b.val,c.val,q.val);

myval = solvetri(a.val+fdeps*a.derivS, b.val+fdeps*b.derivS,....
                c.val+fdeps*c.derivS, q.val+fdeps*q.derivS);
u.derivS=(myval-u.val)./fdeps;

u=class(u,'derivS');
