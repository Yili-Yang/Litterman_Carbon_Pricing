function y=permute(x,p)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


p=derivH(p);
y=permute(x.val,p.val);

y=derivH(y);
y.derivH=permute(x.derivH,p.val);
