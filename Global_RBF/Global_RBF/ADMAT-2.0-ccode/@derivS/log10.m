function sout=log10(s1)
%
%
%  04/2007 -- consider the case for row vectors
% 
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

[m,n] = size(s1.val);
sout.val=log10(s1.val);

if m == 1 || n == 1
    sout.derivS = s1.derivS./(s1.val(:)*log(10));
else
    sout.derivS = s1.derivS./(s1.val*log(10));
end

sout=class(sout,'derivS');
