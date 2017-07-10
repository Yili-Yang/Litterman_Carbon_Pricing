function y=real(x)

%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


y.val=real(x.val);
y.deriv=real(x.deriv);
y=class(y,'deriv');
