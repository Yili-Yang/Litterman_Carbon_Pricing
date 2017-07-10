function y=ones(m,n)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

m1=derivtape(m);
n1=derivtape(n);
y=ones(m1.val,n1.val);
y=derivtape(y,0);
