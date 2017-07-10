function J=dynamicj(fun,x,Extra)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global globp;
if nargin < 3 Extra=[]; end
n=length(x);
globp=n;
fun=deblank(fun);
xx=derivdymJ(x);
xx=setJV(xx,speye(n),Extra);
y=feval(fun,xx);
J=getJV(y);
