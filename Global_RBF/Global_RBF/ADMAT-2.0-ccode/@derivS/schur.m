function [L,U]=schur(A)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global fdeps;

if nargout==2

    [Lv,Uv]=schur(A.val);
    [Lt,Ut]=schur(A.val+fdeps.*A.derivS);
    Ld=(Lt-Lv)./fdeps;
    Ud=(Ut-Uv)./fdeps;
    L.val=Lv; 
    L.derivS=Ld; 
    L=class(L,'derivS');
    U.val=Uv; 
    U.derivS=Ud;
    U=class(U,'derivS');

else

    Lv=schur(A.val);
    Lt=schur(A.val+fdeps.*A.derivS);
    Ld=(Lt-Lv)./fdeps;
    L.val=Lv;
    L.derivS=Ld; 
    L=class(L,'derivS');
end
