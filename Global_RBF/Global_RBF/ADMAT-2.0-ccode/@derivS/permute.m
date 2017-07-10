function y=permute(x,p)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

p=derivS(p);
y=permute(x.val,p.val);
y=derivS(y);
y.derivS=permute(x.derivS,p.val);
