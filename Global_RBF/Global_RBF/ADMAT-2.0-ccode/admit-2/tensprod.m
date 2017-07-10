function TV = Tensprod(fun,x,V,w,Extra)
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
wparm=w;
if nargin < 5 Extra=[]; end
TV=HtimesV('tensfun',x,V,Extra);		
