function sout=prod(s1)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


s1=derivH(s1);
sout.val=prod(s1.val);
m = size(s1.val,1);

s1val=getvalue(s1);
if m==1
    sout.derivH=(prod(s1val)./s1val)*s1.derivH;
else
    sout.derivH=(prod(s1val)./s1val)'*s1.derivH;
end

sout=class(sout,'derivH');
