function HV = vhtimesv(fun,x,V,Extra)
%
%VHtimesV
%
%	VHV = VHtimesV(fun,x,V,Extra)
%
%       Computes the product V^TH*V.
%
%       The user's function is identified by a unique identifier
%       fun. See ADMIT users manual for detail.
%
%       WHV=WHtimesV(fun,x,V) computes V^TH*V at point x.
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
global tapecounter;
global varcounter;
global globp;
if nargin < 4 Extra=[]; end
n=length(x); 
fun=deblank(fun);
globp=size(V,2);

xx=derivH(x,V);
y=feval(fun,xx,Extra);
HV=getyddot(y);
