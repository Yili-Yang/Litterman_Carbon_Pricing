function L=triu(A)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

L.val=triu(A.val);
L.derivH=triu(A.derivH);

L=class(L,'derivH');
