function H=hesssp(fun,n,Extra)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global globp;
globp=n;

fun=deblank(fun);
if nargin < 3 
    Extra=[];
end

x=rand(n,1);
fun=deblank(fun);
xx=derivsph(x,speye(n));
y=feval(fun,xx,Extra);

H=spones(getydot(y));
