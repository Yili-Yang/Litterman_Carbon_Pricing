function sout=prod(s1)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

s1=derivS(s1);
sout.val=prod(s1.val);
m=size(s1.val,1);

if m==1
    sout.derivS=(sout.val./s1.val)*s1.derivS;
else
    sout.derivS=(sout.val./s1.val)'*s1.derivS;
end

sout=class(sout,'derivS');
