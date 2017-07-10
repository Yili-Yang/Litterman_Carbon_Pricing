function sout = ctranspose(s1)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

sout.val=s1.val';

[m,n]=size(s1.val);
if (m>1) && (n>1)
    sout.derivH = s1.derivH';
%     yy=zeros(n,m);
%     yy=s1.derivH';
%     sout.derivH=yy;
else
    sout.derivH=s1.derivH;
end

sout=class(sout,'derivH');
