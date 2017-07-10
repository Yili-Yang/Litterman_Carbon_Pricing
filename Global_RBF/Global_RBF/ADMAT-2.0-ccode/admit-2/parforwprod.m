function JV = parforwprod(fun,x,V)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

Vt=V';
Distribute('Vt');
Bcast('x');
Eval('xx=deriv(x,Vt''); y=exampleparfun(xx);  JV=getydot(y)'';  ');
Collect('JV');
JV=JV';
