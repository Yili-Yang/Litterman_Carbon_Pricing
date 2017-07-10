function sout=colon(s1,s2,s3)
%
%
%
%   March, 2007 -- set output in derivH class
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


s1=getval(s1);
s2=getval(s2);

if nargin > 2
    s3=getval(s3);
    sout=s1:s2:s3;
else
    sout=s1:s2;
end

sout = derivH(sout);