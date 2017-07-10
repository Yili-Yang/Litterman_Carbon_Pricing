function sout=sqrt(s1)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

sout.val=sqrt(s1.val);
m=size(sout.val,1);
[v,i]=find(sout.val==0);
val=sout.val;
val(i)=Inf;

if m==1
    sout.derivS=(1./(2.*val')).*s1.derivS;
else
    sout.derivS=(1./(2.*val)).*s1.derivS;
end
sout=class(sout,'derivS');
