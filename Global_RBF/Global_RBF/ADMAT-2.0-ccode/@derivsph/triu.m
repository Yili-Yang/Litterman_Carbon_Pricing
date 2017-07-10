function L=triu(A)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

L.val=tril(A.val);
L.derivsph=triu(A.derivsph);
L=class(L,'derivsph');

