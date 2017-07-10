function out=diag(V,k)
%
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

%
%
V = derivH(V);

if nargin==1
    out.val = diag(V.val);
    out.derivH = diag(V.derivH);
else
    out.val = diag(V.val,k);
    out.derivH = diag(V.derivH, k);    
end

out = class(out, 'derivH');
