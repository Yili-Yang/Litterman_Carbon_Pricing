function y=ones(m,n)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

m1=getval(m);
n1=getval(n);
y=ones(m1,n1);
y=derivspj(y);
