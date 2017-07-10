function y = conj(x)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

y.val=conj(x.val);
y.derivS=conj(x.derivS);

y=class(y,'derivS');
