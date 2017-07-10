function [e,out] = besselmx(a,b,c,d)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global fdeps
if ~isa(a,'derivS')
    a=derivS(a); 
end

if ~isa(b,'derivS') 
    b=derivS(b);
end

if ~isa(c,'derivS') 
    c=derivS(c);
end

if nargin < 4 
    d=[]; 
end

[s,out]=besselmx(a.val,b.val,c.val,d);

[temp,xx] = besselmx(a.val+fdeps.*a.derivS,b.val+fdeps.*b.derivS,...
    c.val+fdeps.*c.derivS,d);
s1=(temp-s)./fdeps;

e.val=s;
e.derivS=s1;
e=class(e,'derivS');
