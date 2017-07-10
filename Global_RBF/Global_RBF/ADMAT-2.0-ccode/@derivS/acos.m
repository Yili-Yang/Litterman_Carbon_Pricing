function sout = acos(s1)
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

%
%  March, 2007 -- correct the computation of 
%                 the derivative.
%  04/2007 -- consider the case for row vectors
%
m = size(s1.val,1);
sout.val=acos(s1.val);
tmp = -1./sqrt(1-(s1.val).^2);

if m == 1               % row vector or scalar
    sout.derivS = tmp' .* s1.derivS;
else                    % column vector or  matrix
    sout.derivS= tmp .* s1.derivS;
end

sout=class(sout,'derivS');
