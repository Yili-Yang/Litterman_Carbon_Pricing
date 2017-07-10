function sout=transpose(s1)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

sout.val=s1.val';
sout.derivsph=transpose(s1.derivsph);
sout=class(sout,'derivsph');
