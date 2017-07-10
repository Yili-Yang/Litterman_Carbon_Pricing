function y=zeros(m,n)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

m1=derivspj(m);
n1=derivspj(n);
y=zeros(m1.val,n1.val);
y=derivspj(y);
