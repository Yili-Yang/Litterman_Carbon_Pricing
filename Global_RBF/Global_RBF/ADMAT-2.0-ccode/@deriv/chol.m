function L=chol(A)

%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


global globp;
L=chol(A.val);
for i=1:globp
    Lt=chol(A.val+1e-6.*A.deriv(:,:,i));
    Ld(:,:,i)=(Lt-Lv)./1e-6;
end
L.val=Lv;
L.deriv=Ld;
L=class(L,'deriv');

