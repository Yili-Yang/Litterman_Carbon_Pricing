function sout=acsch(s1)
%
%   
%
%  March, 2007 -- correct the computation of 
%                 the derivative.
% 
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


sout.val=acsch(s1.val);

s1val = getvalue(s1);
sout.derivH = -(1./(s1val .* sqrt(s1val.^2 + 1))) .* s1.derivH; 

sout=class(sout,'derivH');
