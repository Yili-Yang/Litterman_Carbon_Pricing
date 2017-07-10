function z = cumsum(A, dim)
%
%   10/2010 -- created the cumsum function for the forward mode
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2010 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global globp;

if nargin == 1
    valA = getval(A);
    [m,n] = size(A);
    if m==1
        z.val = A.val;
        z.deriv = A.deriv;
    else
        z.val = cumsum(getval(A));
        z.deriv = cumsum(getydot(A));
    end
else
    valA = getval(A);
    devA = getydot(A);
    [m,n] = size(valA);
    if dim == 2
        if n == 1
            z.val = valA;
            z.deriv = devA;
        else
            z.val = cumsum(valA, dim);
            z.deriv = cumsum(devA,dim);
        end
    elseif dim == 1
        if m == 1
            z.val = valA;
            z.deriv = devA;
        else
            z.val = cumsum(valA);
            z.deriv = cumsum(devA);
        end
    else
        printf('ADMAT 2.0 does not support higher dimension cumsum than 2.\n');
    end
end

z=class(z,'deriv');