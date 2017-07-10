function y = fliplr(x)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

y.val = fliplr(x.val);
y.derivsph = fliplr(x.derivsph);
y = class(y,'derivsph');
