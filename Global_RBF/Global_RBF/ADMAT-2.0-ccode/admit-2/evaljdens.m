function [f,J]=evalJ(fun,x,Extra)
%
%evalJdens
%	Compute dense Jacobian Via AD
%
%       The user's function is identified by a unique identifier
%       fun. See ADMIT users manual for detail.
%
%       f=evalJdens(fun,x)  computes just the function value at point x, the 
%                       is assume to return same number of output variables as in x.
%       [f,J]=evalJdens(fun,x) Also computes the n x n dense Jacobian at x.
%
%       ******************************************************************
%       *              ADMIT Project   10-1-96                           *
%       *              Copyright (c) 1996 Cornell University.            *
%       ******************************************************************



n=length(x);
if nargin < 2 error('Need at least Two input Arguments. see help evalJ'); end
if nargin < 3 Extra=[]; end

if (nargout==1)
f=feval(fun,x,Extra);
else
n=length(x);
[f,J]=forwprod(fun,x,eye(n),[],Extra);
end
