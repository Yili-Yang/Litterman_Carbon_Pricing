function J=jacsp(fun,m,n,Extra)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  compute the sparsity structure of Jacobian matrix
%
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global globp;
if isa(fun, 'string')
    fun=deblank(fun);
end
if nargin < 4 Extra=[]; end
if nargin < 3 n=[]; end
if isempty(n) n=m; end 
n=getval(n);
globp=n;
x=rand(n,1);
xx = derivspj(x,speye(n));
y = feval(fun,xx,Extra);
J = spones(getydot(y));
