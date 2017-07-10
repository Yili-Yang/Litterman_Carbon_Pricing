function [E,v]=eig(A)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global fdeps;
if nargout==1
    Ev=eig(A.val); 
else
    [Ev,vv]=eig(A.val);
end

if nargout==1 
    Et=eig(A.val+fdeps.*A.derivS); 
else
    [Et,vt]=eig(A.val+fdeps.*A.derivS); 
end

Ed=(Et-Ev)./fdeps;
E.val=Ev; 
E.derivS=Ed;
E=class(E,'derivS');

if nargout==2
    vd=(vt-vv)./fdeps;
    v.val=vv; v.derivS=vd; v=class(v,'derivS');
end

