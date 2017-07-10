function [HV, f, grad] = HtimesV(fun,x,V,Extra)
%
%HtimesV
%
%	[HV, f, grad] = HtimesV(fun,x,V,Extra)
%
%	Computes the product H*V. 
%
%       The user's function is identified by a unique identifier
%       fun. See ADMIT users manual for detail.
%
%       [HV, f, grad]=HtimesV(fun,x,V) computes H*V at point x.
%
%       Please refer to ADMIT users manual for complete reference.
%
%       ALSO SEE revprod, jacsp
%
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global tape;
global globp;
global tape_begin;

if nargin < 4
    Extra=[];
end
cleanup;
n=length(x);

fun=deblank(fun);
globp=size(V,2);
xx=derivtapeH(x,1,V);
y=feval(fun,xx,Extra);
if nargout == 3 
    f = getval(y);
grad = getydot(y);
end
% if n == 1
%     W = 1;
% else
     W = eye(globp);
% end
if globp~=1
    HV = parsetape(W);
else
    HV =  parsetape(1);
 end

% HV=tape(tape_begin).W;

