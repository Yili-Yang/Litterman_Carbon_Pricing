function sout = csc(s1)
% 
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

%
%
sout.val = csc(s1.val);
sout.derivsph = updatesph1(s1);

sout=class(sout,'derivsph');
