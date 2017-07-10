function [L,U]=lu(A)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global fdeps;
global globp;

[Lv,Uv]=lu(A.val);
for i=1:globp
    [Lt,Ut]=lu(A.val+fdeps.*A.deriv(:,:,i));
    Ld(:,:,i)=(Lt-Lv).*(1/fdeps);
    Ud(:,:,i)=(Ut-Uv).*(1/fdeps);
end
L.val=Lv;
L.deriv=Ld;
L=class(L,'derivtapeH');

U.val=Uv;
U.deriv=Ud;
U=class(U,'derivtapeH');

