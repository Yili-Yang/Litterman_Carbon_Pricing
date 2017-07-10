function [U,S,V]=svd(A,p)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global fdeps;

if nargout ==1 
if nargin ==2 
    Uv=svd(A.val,p); 
else
    Uv=svd(A.val); 
end

if nargin==2
    Ut=svd(A.val+fdeps.*A.derivH,p);
else
    Ut=svd(A.val+fdeps.*A.derivH);
end

Ud=(Ut-Uv)./fdeps;
U.val=Uv;
U.derivH=Ud; 
U=class(U,'derivH');

else
    
    if nargin ==2 
        [Uv,Sv,Vv]=svd(A.val,p); 
    else
        [Uv,Sv,Vv]=svd(A.val); 
    end
    if nargin ==2
        [Ut,St,Vt]=svd(A.val+fdeps.*A.derivH,p);
    else
        [Ut,St,Vt]=svd(A.val+fdeps.*A.derivH);
    end
    Ud=(Ut-Uv)./fdeps;
    Sd=(St-Sv)./fdeps;
    Vd=(Vt-Vv)./fdeps;
    U.val=Uv; U.derivH=Ud; U=class(U,'derivH');
    S.val=Sv; S.derivH=Sd; S=class(S,'derivH');
    V.val=Vv; V.derivH=Vd; V=class(V,'derivH');
    
end
