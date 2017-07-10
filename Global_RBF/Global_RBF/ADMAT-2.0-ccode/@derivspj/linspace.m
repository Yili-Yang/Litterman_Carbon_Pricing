function s=linspace(x1,x2,N)
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************
%
s=linspace(getval(x1),getval(x2),getval(N));
s=derivspj(s);
