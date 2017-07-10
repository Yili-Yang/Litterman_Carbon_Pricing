function [a,out] = besselmx(a,b,c,d)
%
%
%  04/2007 -- rmoved unused variables
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global globp;

[s,out]=besselmx(a,b,c.val,d);
for i=1:globp
    [temp,xx]=besselmx(a,b,c.val+1e-6.*c.derivspj(:,i),d);
    s1(:,i)=(temp-s)./1e-6;
end
a.val=s;
a.derivspj=s1;
a=class(a,'derivspj');
