function E=eig(A)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


global fdeps;

Ev=eig(A.val);
Et=eig(A.val+fdeps.*A.derivH);
Ed=(Et-Ev)./fdeps;
E.val=Ev;
E.derivH=Ed; 

E=class(E,'derivH');
