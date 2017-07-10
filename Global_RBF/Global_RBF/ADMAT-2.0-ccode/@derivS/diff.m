function sout = diff(s1)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

sout.val=diff(getval(s1));
sout.derivS=squeeze(diff(s1.derivS));
m=size(sout.val,1);
if (m==1)
    sout.derivS=sout.derivS(:);
end

sout=class(sout,'derivS');
