function y=real(x)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

y.val=real(x.val);
y.derivS=real(x.derivS);

y=class(y,'derivS');
