function sout = triu(s1)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global globp;

sout.val=triu(s1.val);
[m,n]=size(s1.val);

sout.deriv=derivtape(zeros(m, n, globp),0);

for i=1:globp
    sout.deriv(:,:,i)=triu(s1.deriv(:,:,i));
end

sout=class(sout,'derivtapeH');
