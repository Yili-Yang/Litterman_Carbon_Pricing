function [f,JV] = forwprod(fun,x,V,m,Extra)
%
%forwprod
%
%	Computes forward mode product J*V  
%
%       The user's function is identified by a unique identifier
%       fun. See ADMIT users manual for detail.
%
%       [f,JV]=forwprod(fun,x,V,m,Extra) computes J*V at point x.
%       when using ADMAT you can leave m blank.
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

global globp;
n=length(x);
if nargin < 5 Extra=[]; end
if nargin < 4 m=[]; end
if isempty(m) m=n; end

[p,q]=size(x);
if ((p==1) || (q==1))
    globp=size(V,2);
else
    globp=size(V,3);
end

if isa(fun, 'string')
    fun=deblank(fun);
end
if globp==1
    xx=derivS(x,V);
else
    xx=deriv(x,V);
end
y=feval(fun,xx,Extra);
if globp==1
    JV = getydot(y)';
else
   JV=getydot(y);
end
f=getval(y);
