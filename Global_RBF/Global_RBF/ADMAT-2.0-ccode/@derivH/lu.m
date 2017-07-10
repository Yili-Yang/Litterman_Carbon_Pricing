function [L,U]=lu(A)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


global fdeps;

[Lv,Uv]=lu(A.val);
[Lt,Ut]=lu(A.val+fdeps.*A.derivH);
Ld=(Lt-Lv)./fdeps;
Ud=(Ut-Uv)./fdeps;

L.val=Lv; 
L.derivH=Ld;
L=class(L,'derivH');

U.val=Uv; 
U.derivH=Ud; 
U=class(U,'derivH');

