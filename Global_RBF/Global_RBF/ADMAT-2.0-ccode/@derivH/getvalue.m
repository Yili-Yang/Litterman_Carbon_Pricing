function f=getvalue(p)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


f.val=p.val;

f.derivS=getval(p.derivH);
f=derivS(f.val,f.derivS);
