function [E,v]=eig(A)

%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


global globp;
global fdeps;

if nargout==2
    [Ev, vv] =eig(A.val);
else 
    Ev = eig(A.val);
end

for i=1:globp
    if nargout==2
        [Et, vt]=eig(A.val+fdeps.*A.deriv(:,:,i));
    else
        Et=eig(A.val+fdeps.*A.deriv(:,:,i));
    end
    Ed(:,:,i)=(Et-Ev)./fdeps;
    if nargout == 2
        vd(:,:,i)=(vt-vv)./fdeps;
    end

end

E.val=Ev;
E.deriv=Ed;
E=class(E,'deriv');
if nargout == 2
    v.val=vv; v.deriv=vd; v=class(v,'deriv');
end


