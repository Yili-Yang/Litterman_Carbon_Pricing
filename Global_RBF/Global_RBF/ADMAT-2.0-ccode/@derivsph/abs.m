function sout = abs(s1)
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

%
%  04/2007 -- removed unused variables
%
sout.val=abs(s1.val);

sout.derivsph=s1.derivsph;

sout=class(sout,'derivsph');
