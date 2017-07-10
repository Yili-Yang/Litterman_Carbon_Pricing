function sout=rem(s1,s2)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


s1 = derivH(s1);
s2 = derivH(s2);
sout.val = rem(s1.val,s2.val);
sout.derivH = s1.derivH - ...
    fix(getvalue(s1)./getvalue(s2)).*s2.derivH;

sout=class(sout,'derivH');
