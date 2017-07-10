function sout=ceil(s1)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

sout.val=ceil(s1.val);
sout.deriv=s1.deriv;

sout=class(sout,'derivtapeH');
