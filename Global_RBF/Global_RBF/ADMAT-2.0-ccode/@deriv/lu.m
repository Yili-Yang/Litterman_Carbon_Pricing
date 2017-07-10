function [L,U]=lu(A)
%
%  
%
%   03/2007 -- allocate Ld and Ud before the "for" loop
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


global globp;
global fdeps
[Lv,Uv]=lu(A.val);
[m,n] = size(Lv);
Ld = zeros(m,n,globp);
Ud = zeros(m,n,globp);
for i=1:globp
    [Lt,Ut]=lu(A.val+fdeps.*A.deriv(:,:,i));
    Ld(:,:,i)=(Lt-Lv)./fdeps;
    Ud(:,:,i)=(Ut-Uv)./fdeps;
end
L.val=Lv; L.deriv=Ld; L=class(L,'deriv');
U.val=Uv; U.deriv=Ud; U=class(U,'deriv');

