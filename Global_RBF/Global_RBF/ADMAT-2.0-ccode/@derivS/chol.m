function L=chol(A)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

L=chol(A.val);
Lt=chol(A.val+1e-6.*A.derivS);
Ld=(Lt-Lv)./1e-6;
L.val=Lv;
L.derivS=Ld; 

L=class(L,'derivS');

