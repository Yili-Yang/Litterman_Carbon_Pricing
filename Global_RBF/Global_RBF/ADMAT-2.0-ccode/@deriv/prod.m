function sout=prod(s1)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


sout.val=prod(s1.val);
[m,n]=size(s1.val);
if m==1
    sout.deriv=(sout.val./s1.val)*s1.deriv;
else
    sout.deriv=(sout.val./s1.val)'*s1.deriv;
end
sout=class(sout,'deriv');
