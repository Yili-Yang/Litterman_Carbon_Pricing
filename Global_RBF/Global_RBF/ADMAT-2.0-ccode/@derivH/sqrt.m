function sout=sqrt(s1)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


sout.val=sqrt(s1.val);
m=size(sout.val,1);
% [v,i]=find(sout.val==0);
% val=sout.val;
% val(i)=Inf;

s1val = getvalue(s1);
tmp = 1./(2.*sqrt(s1val));
if m == 1 || n == 1
    sout.derivH = tmp(:).*s1.derivH;
else
    sout.derivH = tmp .* s1.derivH;
end

sout=class(sout,'derivS');

