function sout=rem(s1,s2)
%
%
%  04/2007 -- consider the case for row vector
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

s1=derivS(s1);
s2=derivS(s2);

sout.val=rem(s1.val,s2.val);
[m,n]  = size(sout.val);
tmp = fix(s1.val./s2.val);
if m == 1 || n == 1
    sout.derivS=s1.derivS-tmp(:).*s2.derivS;
else
    sout.derivS=s1.derivS-tmp.*s2.derivS;
end
sout=class(sout,'derivS');
