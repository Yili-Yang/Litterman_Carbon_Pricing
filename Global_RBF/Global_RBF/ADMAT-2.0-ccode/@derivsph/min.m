function sout = min(s1,s2)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

s1=derivsph(s1);
if nargin > 1
    s2=derivsph(s2);
    sout.val = min(getval(s1),getval(s2));
    sout.derivsph = s1.derivsph + s2.derivsph;
else
    sout.val = min(getval(s1));
    [temp,I] = min(getval(s1));
    sout.derivsph = s1.derivsph(I,:);
end

sout=derivsph(sout);
