function sout = transpose(s1)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global globp;

sout.val=s1.val';
[m,n] = size(getval(sout.val));
if n>1 && m>1
    t = getval(sout.deriv);
    for i = 1: globp
        t(:,:,i) = t(:,:,i)';
    end
    sout.deriv = t;
else        
sout.deriv=1*s1.deriv;
end
sout=class(sout,'derivtapeH');
