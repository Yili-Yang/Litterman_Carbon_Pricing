function [Q,R]=qr(A,p)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global fdeps;

if nargin ==2 
    [Qv,Rv]=qr(A.val,p); 
else
    [Qv,Rv]=qr(A.val); 
end

if nargin ==2 
    [Qt,Rt]=qr(A.val+fdeps.*A.derivS,p); 
else
    [Qt,Rt]=qr(A.val+fdeps.*A.derivS);
end

Qd=(Qt-Qv)./fdeps;
Rd=(Rt-Rv)./fdeps;
Q.val=Qv;
Q.derivS=Qd;
Q=class(Q,'derivS');

R.val=Rv;
R.derivS=Rd;
R=class(R,'derivS');

