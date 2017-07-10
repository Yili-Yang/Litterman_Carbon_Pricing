function sout=expm(s1)
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
sout.val=expm(s1.val);

if m == 1
    sout.derivS=sout.val(:).*s1.derivS;
else
    sout.derivS=sout.val.*s1.derivS;
end

sout=class(sout,'derivS');
