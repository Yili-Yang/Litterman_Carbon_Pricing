function sout = sum(s1)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

sout.val=sum(s1.val);
sout.derivsph=sum(s1.derivsph);
sout=class(sout,'derivsph');
