function [L,U]=schur(A)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global globp;
global fdeps
if nargout==2

    [Lv,Uv]=schur(A.val);
    for i=1:globp
        [Lt,Ut]=schur(A.val+fdeps.*A.derivspj(:,:,i));
        Ld(:,:,i)=(Lt-Lv)./fdeps;
        Ud(:,:,i)=(Ut-Uv)./fdeps;
    end
    L.val=Lv; L.derivspj=Ld; L=class(L,'derivspj');
    U.val=Uv; U.derivspj=Ud; U=class(U,'derivspj');

else

    Lv=schur(A.val);
    for i=1:globp
        Lt=schur(A.val+fdeps.*A.derivspj(:,:,i));
        Ld(:,:,i)=(Lt-Lv)./fdeps;
    end
    L.val=Lv; L.derivspj=Ld; L=class(L,'derivspj');
end

