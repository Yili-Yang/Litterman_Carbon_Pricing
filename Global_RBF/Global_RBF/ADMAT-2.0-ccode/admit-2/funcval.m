function [val,grad] = funcval(fun,x,Extra)
%
%funcvalJ
%
%       Computes  the value and gradient  of a scalar function
%
%       The user's function is identified by a unique identifier
%       fun. See ADMIT users manual for detail.
%
%       v=funcval(fun,x) 
%       [v,grad]=funcval(fun,x) 
%
%       Please refer to ADMIT users manual for complete reference.
%
%       ALSO SEE HessSP. HtimesV
%
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


if nargin < 3 Extra=[]; end
fun=deblank(fun);
	if nargout==1
		val=feval(fun,x,Extra);
    else
        n = length(x);
		[val,grad]=forwprod(fun,x,eye(n),[],Extra);
	end
