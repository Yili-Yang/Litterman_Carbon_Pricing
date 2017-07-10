function [U,S,V]=svd(A,p)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


global globp;
global fdeps

if nargout ==1
    if nargin ==2 
        Uv=svd(A.val,p); 
    else
        Uv=svd(A.val); 
    end

    for i=1:globp
        if nargin==2
            Ut=svd(A.val+fdeps.*A.deriv(:,:,i),p);
        else
            Ut=svd(A.val+fdeps.*A.deriv(:,:,i));
        end

        Ud(:,:,i)=(Ut-Uv)./fdeps;
    end
    U.val=Uv; U.deriv=Ud; U=class(U,'deriv');

else

    if nargin ==2
        [Uv,Sv,Vv]=svd(A.val,p); 
    else
        [Uv,Sv,Vv]=svd(A.val); 
    end
    for i=1:globp
        if nargin ==2
            [Ut,St,Vt]=svd(A.val+fdeps.*A.deriv(:,:,i),p);
        else
            [Ut,St,Vt]=svd(A.val+fdeps.*A.deriv(:,:,i));
        end
        Ud(:,:,i)=(Ut-Uv)./fdeps;
        Sd(:,:,i)=(St-Sv)./fdeps;
        Vd(:,:,i)=(Vt-Vv)./fdeps;
    end
    U.val=Uv; U.deriv=Ud; U=class(U,'deriv');
    S.val=Sv; S.deriv=Sd; S=class(S,'deriv');
    V.val=Vv; V.deriv=Vd; V=class(V,'deriv');
end
