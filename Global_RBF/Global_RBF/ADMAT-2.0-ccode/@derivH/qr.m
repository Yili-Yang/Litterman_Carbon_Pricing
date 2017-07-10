function [Q,R]=qr(A)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


global fdeps;

[Qv,Rv]=qr(A.val);
[Qt,Rt]=qr(A.val+fdeps.*A.derivH);
Qd=(Qt-Qv)./fdeps;
Rd=(Rt-Rv)./fdeps;

Q.val=Qv;
Q.derivH=Qd; 
Q=class(Q,'derivH');

R.val=Rv; 
R.derivH=Rd; 
R=class(R,'derivH');

