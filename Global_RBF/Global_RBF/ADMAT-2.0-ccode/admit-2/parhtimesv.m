function HV = parhtimesv(fun,x,V)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global tape
global varcounter
global globp

Eval('varcounter=1;');
Vt=V';
Distribute('Vt');
Bcast('x');
Eval('xx=derivtapeH(x,Vt''); y=exampleparfun(xx); parsetape(1);   HV=tape(1).W'';  ');
Collect('HV');
HV=HV';
