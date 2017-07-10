function sout=transpose(s1)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global globp;
sout.val=s1.val.';

[m,n]=size(s1.val);

if (m>1) && (n>1)
    yy=zeros(n,m,globp);
    for i=1:globp 
        yy(:,:,i)=s1.deriv(:,:,i).';
    end
    sout.deriv=yy;
else
    sout.deriv=s1.deriv;
end
sout=class(sout,'deriv');
