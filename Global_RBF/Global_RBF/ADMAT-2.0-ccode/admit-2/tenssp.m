function SPT = Tensprod(fun,n,m,Extra)
%
%Tensprod
%
%       Computes the Hessian Matrix product H*V, where
%       H is the Hessian of (F(x)'*w) (a tensor vector product)
%
%       The user's function is identified by a unique identifier
%       fun. See ADMIT users manual for detail.
%
%
%       TV=Tensprod(fun,x,V,w)
%
%       Please refer to ADMIT users manual for complete reference.
%
%       ALSO SEE funcval, HessSP, HtimesV
%
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global funtens
global wparm
fun=deblank(fun);
funtens=fun;
if nargin < 4 Extra=[]; end
if nargin < 3 m=[]; end
if isempty(m) m=n; end
wparm=rand(m,1);
SPT=hesssp('tensfun',n,Extra);		
