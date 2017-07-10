function sout = diff(s1)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global globp;

sout.val=diff(s1.val);
sout.derivsph=squeeze(diff(s1.derivsph));
m = size(getval(sout),1);
if (m==1) && (globp==1)
    sout.derivsph=sout.derivsph(:);
end
sout=class(sout,'derivsph');
