function sout=uminus(s1)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

sout.val=-s1.val;
sout.derivspj = s1.derivspj;
sout = class(sout, 'derivspj');
