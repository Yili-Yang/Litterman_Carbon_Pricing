function [U,S,V]=svd(A,p)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global fdeps;

if nargout ==1
    if nargin==2
        Uv=svd(A.val,p);
        Ut=svd(A.val+fdeps.*A.derivS,p);
    else
        Uv=svd(A.val);
        Ut=svd(A.val+fdeps.*A.derivS);
    end

    Ud=(Ut-Uv)./fdeps;
    U.val=Uv; 
    U.derivS=Ud;
    U=class(U,'derivS');
else
    if nargin ==2
        [Uv,Sv,Vv]=svd(A.val,p);
        [Ut,St,Vt]=svd(A.val+fdeps.*A.derivS,p);
    else
        [Uv,Sv,Vv]=svd(A.val);
        [Ut,St,Vt]=svd(A.val+fdeps.*A.derivS);
    end
    Ud=(Ut-Uv)./fdeps;
    Sd=(St-Sv)./fdeps;
    Vd=(Vt-Vv)./fdeps;
    U.val=Uv;
    U.derivS=Ud; 
    U=class(U,'derivS');
    S.val=Sv;
    S.derivS=Sd; 
    S=class(S,'derivS');
    V.val=Vv;
    V.derivS=Vd; 
    V=class(V,'derivS');

end
