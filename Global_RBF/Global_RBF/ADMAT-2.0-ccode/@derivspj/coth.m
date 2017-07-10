function sout=coth(s1)
%
%
%  04/2007 -- rmoved unused variables
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

sout.val=coth(s1.val);
sout.derivspj=s1.derivspj;
sout=class(sout,'derivspj');
