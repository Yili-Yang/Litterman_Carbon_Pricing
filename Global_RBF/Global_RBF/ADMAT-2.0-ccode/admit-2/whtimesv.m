function HV = whtimesv(fun,x,V,W,Extra)
%
%WHtimesV
%
%       WHV = WHtimesV(fun,x,V,W,Extra)
%
%       Computes the product W^TH*V.
%
%       The user's function is identified by a unique identifier
%       fun. See ADMIT users manual for detail.
%
%       WHV=WHtimesV(fun,x,V,W) computes W^TH*V at point x.
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


if nargin < 5 Extra=[]; end
if nargin < 4 W=[]; end

if isempty(W)
HV=VHtimesV(fun,x,V,Extra);
else
VHV=VHtimesV(fun,x,V,Extra);
WHW=VHtimesV(fun,x,W,Extra);
WHWplus=VHtimesV(fun,x,V+W,Extra);

HV= (WHWplus-VHV-WHW)./2;
end
