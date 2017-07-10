function [sout,e] = log2(s1)
%
%  04/2007 -- consider the case for row vectors
% 
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

if nargout==1
    sout.val=log2(s1.val);
else
    [sout.val,e]=log2(s1.val);
end

[m,n] = size(s1.val);

if m == 1 || n == 1
    sout.derivS=s1.derivS./(s1.val(:)*log(2));
else
    sout.derivS=s1.derivS./(s1.val*log(2));
end

sout=class(sout,'derivS');
