function sout=asin(s1)
%
%
%  March, 2007 -- correct the computation of 
%                 the derivative.
%  04/2007 -- consider the case for row vectors
% 
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

m = size(s1.val,1);
sout.val=asin(s1.val);
tmp = (1./sqrt(1 - (s1.val).^2));
if m == 1
    sout.derivS = tmp' .* s1.derivS;
else
    sout.derivS = tmp .* s1.derivS;
end
sout=class(sout,'derivS');
