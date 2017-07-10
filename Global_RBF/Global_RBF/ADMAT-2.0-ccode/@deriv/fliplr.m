function y=fliplr(x)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global globp;

y.val=fliplr(x.val);
[m,n] = size(x.val);

if m == 1 % x.val is a row vector
    y.deriv = flipud(x.deriv);
elseif n == 1   % x.deriv is a column vector
    y.deriv = x.deriv;
else    % x.deriv is a matrix
    y.deriv = x.deriv;
    for i = 1 : globp
        y.deriv(:,:,i) = fliplr(x.deriv(:,:,i));
    end
end
y=class(y,'deriv');
