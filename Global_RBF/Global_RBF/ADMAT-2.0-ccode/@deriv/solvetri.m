function u=solvetri(a,b,c,q)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


global globp;
global fdeps
if ~isa(a,'deriv') a =deriv(a); end
if ~isa(b,'deriv') b =deriv(b); end
if ~isa(c,'deriv') c =deriv(c); end
if ~isa(q,'deriv') q =deriv(q); end

u.val=solvetri(a.val,b.val,c.val,q.val);
[r,s]=size(q.val);

if s==1
    for i=1:globp
        myval=solvetri(a.val+fdeps*a.deriv(:,i),b.val+ ...
            fdeps*b.deriv(:,i),c.val+fdeps*c.deriv(:,i),q.val+fdeps*q.deriv(:,i));
        u.deriv(:,:,i)=(myval-u.val)./fdeps;
    end
else

    for i=1:globp
        myval=solvetri(a.val+fdeps*a.deriv(:,i),b.val+...
            fdeps*b.deriv(:,i),c.val+fdeps*c.deriv(:,i),q.val+fdeps*q.deriv(:,:,i));
        u.deriv(:,:,i)=(myval-u.val)./fdeps;
    end

end
u=class(u,'deriv');
