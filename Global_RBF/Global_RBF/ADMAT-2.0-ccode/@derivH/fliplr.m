function y = fliplr(x)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


y.val=fliplr(x.val);
y.derivH=fliplr(x.derivH);

y=class(y,'derivH');
