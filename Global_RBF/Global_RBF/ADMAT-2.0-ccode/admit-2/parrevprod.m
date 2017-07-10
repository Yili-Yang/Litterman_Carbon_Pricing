function WJ = parrevprod(fun,x,W)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global tape
global varcounter
Eval('varcounter=1;');
Wt=W';
Distribute('Wt');
Bcast('x');
Eval('xx=derivtape(x); y=exampleparfun(xx); parsetape(Wt'');   WJ=tape(1).W'';  ');
Collect('WJ');
WJ=WJ';
