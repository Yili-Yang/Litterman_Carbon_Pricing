function sout = sum(s1)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


[m,n] = size(getval(s1.val));
if m == 1 && n == 1        % s1.val is a scalar
    sout.val = s1.val;
    sout.deriv = s1.deriv;
else
    sout.val=sum(s1.val);
    sout.deriv=sum(s1.deriv);
end

sout=class(sout,'derivtapeH');
