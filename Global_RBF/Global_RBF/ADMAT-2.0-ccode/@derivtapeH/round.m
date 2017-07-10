function sout = round(s1)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

sout.val = round(s1.val);
sout.deriv = 0 + s1.deriv;

sout=class(sout,'derivtapeH');
