function [Q,R]=qr(A,p)
% 
%
%   03/2007 -- rearrage the program for readibility
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


global globp;
global fdeps
if nargin == 2 
    [Qv,Rv]=qr(A.val,p); 
else
    [Qv,Rv]=qr(A.val); 
end

for i=1:globp
    if nargin == 2 
        [Qt,Rt]=qr(A.val+fdeps.*A.deriv(:,:,i),p); 
    else
        [Qt,Rt]=qr(A.val+fdeps.*A.deriv(:,:,i)); 
    end
    Qd(:,:,i)=(Qt-Qv)./fdeps;
    Rd(:,:,i)=(Rt-Rv)./fdeps;
end

Q.val=Qv; Q.deriv=Qd; Q=class(Q,'deriv');
R.val=Rv; R.deriv=Rd; R=class(R,'deriv');

