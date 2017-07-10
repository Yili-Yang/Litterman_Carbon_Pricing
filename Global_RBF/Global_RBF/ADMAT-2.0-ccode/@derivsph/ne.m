function sout = ne(s1,s2)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

s1=derivsph(s1);
s2=derivsph(s2);

sout=(getval(s1)~=getval(s2));
