function s = linspace(x1,x2,N)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

N = getval(N);
x1=derivsph(x1);
x2=derivsph(x2);

s=linspace(x1.val,x2.val,N);
s=derivsph(s);
