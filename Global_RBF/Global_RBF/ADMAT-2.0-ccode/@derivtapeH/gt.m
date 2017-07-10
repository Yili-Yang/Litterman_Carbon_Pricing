function sout = gt(s1,s2)
%
%   August 2008   -- replace s1.val with getval(s1)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

sout=(getval(s1)>getval(s2));
