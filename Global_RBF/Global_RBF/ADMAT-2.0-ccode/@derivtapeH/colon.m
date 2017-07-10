function sout = colon(s1,s2,s3)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


if nargin > 2
    sout=getval(s1):getval(s2):getval(s3);
else
    sout=getval(s1):getval(s2);
end
sout=derivtapeH(sout,0);
