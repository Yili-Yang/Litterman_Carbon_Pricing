function sout = asinh(s1)
%
%
%  04/2007 -- consider the case for row vectors
% 
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

m = size(s1.val,1);
sout.val=asinh(s1.val);
tmp = (1./sqrt((s1.val).^2 + 1));
if m == 1
    sout.derivS = tmp'.*s1.derivS;
else
    sout.derivS = tmp .* s1.derivS;
end

sout=class(sout,'derivS');
