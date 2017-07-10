function [a,out]=besselmx(a,b,c,d)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global globp;

[s,out]=besselmx(a,b,c.val,d);
for i=1:globp
    [temp,xx]=besselmx(a,b,c.val+1e-6.*c.deriv(:,i),d);
    s1(:,i)=(temp-s)./1e-6;
end
a.val=s;
a.deriv=s1;
a=class(a,'derivtapeH');
