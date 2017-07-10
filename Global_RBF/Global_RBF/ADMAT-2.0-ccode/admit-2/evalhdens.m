function [f,g,H]=evalHdens(fun,x,Extra)
%
%evalJdens
%	Compute dense Hessian Via AD
%
%       The user's function is identified by a unique identifier
%       fun. See ADMIT users manual for detail.
%
%       f=evalHdens(fun,x)  computes just the function value at point x, the 
%                       is assume to return same number of output variables as in x.
%       [f,g]=evalHdens(fun,x) Also computes the gradient at x.
%       [f,g,H]=evalHdens(fun,x) Also computes the dense n x n Hessian at x.
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************




n=length(x);
if nargin < 2 error('Need at least Two input Arguments. see help evalJ'); end
if nargin < 3 Extra=[]; end

if (nargout==1)
f=feval(fun,x,Extra);
else
[f,g]=revprod(fun,x,1,Extra);
if nargout==3
n=length(x);
H=HtimesV(fun,x,eye(n),Extra);
end
end
