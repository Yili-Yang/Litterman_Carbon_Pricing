function [e,out]=besselmx(a,b,c,d)
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


global globp;
global fdeps;
if ~isa(a,'deriv') a=deriv(a); end
if ~isa(b,'deriv') b=deriv(b); end
if ~isa(c,'deriv') c=deriv(c); end

if nargin < 4 d=[]; end

[s,out]=besselmx(a.val,b.val,c.val,d);
for i=1:globp
    [temp,xx]=besselmx(a.val+fdeps.*a.deriv(:,i),b.val + ...
        fdeps.*b.deriv(:,i),c.val+fdeps.*c.deriv(:,i),d);
    s1(:,i)=(temp-s)./fdeps;
end
e.val=s;
e.deriv=s1;
e=class(e,'deriv');
