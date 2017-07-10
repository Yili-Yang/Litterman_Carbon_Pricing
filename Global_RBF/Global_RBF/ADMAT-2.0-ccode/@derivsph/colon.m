function sout = colon(s1,s2,s3)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

s1=derivsph(s1);
s2=derivsph(s2);
if nargin > 2
    s3=derivsph(s3);
    sout=s1.val:s2.val:s3.val;
else
    sout=s1.val:s2.val;
end

sout=derivsph(sout);
