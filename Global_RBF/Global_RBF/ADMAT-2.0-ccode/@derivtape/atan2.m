function sout=atan2(s1,s2)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

s1 = derivtape(s1);
s2 = derivtape(s2);

sout=(sign(s1).*(sign(s2)<0))*pi+atan(s1./s2);

sout = class(sout, 'derivtape');
