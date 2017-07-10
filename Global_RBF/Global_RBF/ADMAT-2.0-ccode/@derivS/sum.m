function sout=sum(s1, DIM)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

if nargin == 1
    DIM = 1;
end
sout.val = sum(s1.val, DIM);
m = size(s1.val);
if length(m) == 3
    sout.derivS = sum(s1.derivS, DIM);
else
    sout.derivS = sum(s1.derivS, DIM);
    sout.derivS = sout.derivS(:);
end

sout=class(sout,'derivS');
