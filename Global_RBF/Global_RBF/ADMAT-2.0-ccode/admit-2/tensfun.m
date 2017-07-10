function f= tensfun(x,Extra)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global funtens
global wparm
if nargin < 3 Extra=[]; end
z=feval(funtens,x,Extra);
f=z'*wparm;
