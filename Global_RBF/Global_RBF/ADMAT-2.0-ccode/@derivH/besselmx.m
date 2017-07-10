function [a,out]=besselmx(a,b,c,d)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


[s,out]=besselmx(a,b,c.val,d);
[temp,xx]=besselmx(a,b,c.val+1e-6.*c.derivH,d);
s1=(temp-s)./1e-6;
a.val=s;
a.derivH=s1;

a=class(a,'derivH');
