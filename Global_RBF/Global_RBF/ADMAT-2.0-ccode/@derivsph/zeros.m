function y=zeros(m,n)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

m1=derivsph(m);
n1=derivsph(n);
y=zeros(getval(m1),getval(n1));
y=derivsph(y);
