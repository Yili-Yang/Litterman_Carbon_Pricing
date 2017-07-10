function sout = ceil(s1)
% 
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

%
%
s1 = derivsph(s1);
sout.val = ceil(getval(s1));
sout.derivsph = s1.derivsph;

sout = class(sout, 'derivsph');
