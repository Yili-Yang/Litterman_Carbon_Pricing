function sout=transpose(s1)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

sout.val=s1.val';
[m,n]=size(s1.val);
if (m>1) && (n>1)
    sout.derivS=s1.derivS';
else
    sout.derivS=s1.derivS;
end

sout=class(sout,'derivS');
