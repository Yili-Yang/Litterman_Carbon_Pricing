function sout=tanh(s1)
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


sout.val=tanh(s1.val);
[m,n] = size(sout.val);
tmp = 1./(cosh(s1.val) .* cosh(s1.val));

if m == 1 || n == 1
    sout.derivS = tmp(:).*s1.derivS;
else
    sout.derivS = tmp .* s1.derivS;
end

sout=class(sout,'derivS');
