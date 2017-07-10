function sout=diff(s1)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


sout.val=diff(getval(s1));
sout.derivH=squeeze(diff(s1.derivH));
m=size(sout.val,1);
if (m==1)
    sout.derivH=sout.derivH(:);
end

sout=class(sout,'derivH');
