function val = funcvalJ(fun,x,m,Extra)
%
%funcvalJ
%
%       Computes  the value of the (vector) function
%
%       The user's function is identified by a unique identifier
%       fun. See ADMIT users manual for detail.
%
%       f=funcvalJ(fun,x) 
%
%       Please refer to ADMIT users manual for complete reference.
%
%       ALSO SEE revprod, forwprod, funcval, JacSP
%
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

n=length(x);
if isa(fun, 'string')
    fun=deblank(fun);
end
if nargin < 3 m=[]; end
if nargin < 4 Extra=[]; end
if isempty(m) m=n; end

val=feval(fun,x,Extra);
