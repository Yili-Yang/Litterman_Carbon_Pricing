function [f,JV] = fdapprox(fun,x,V,m,epsvec,Extra)
%
%fdapprox
%
%       Computes the J*V product using Finite difference
%
%       The user's function is identified by a unique identifier
%       fun. See ADMIT users manual for detail.
%
%       [f,JV]=fdapprox(fun,x,V)
%
%       Please refer to ADMIT users manual for complete reference.
%
%       ALSO SEE funcvalJ, revprod, forwprod, JacSP
%
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


if nargin < 4 m=length(x);
    if nargin < 5 epsvec=[]; end
    if nargin < 6 Extra=[]; end
end
if isempty(epsvec) 
    epsvec=1e-5.*ones(size(V,2),1);
end

fun=deblank(fun);
f=feval(fun,x,Extra);
JV=zeros(m,size(V,2));
for i=1:size(V,2)
    val=feval(fun,x+epsvec(i).*V(:,i),Extra);
    JV(:,i)=(val-f)./epsvec(i);
end
