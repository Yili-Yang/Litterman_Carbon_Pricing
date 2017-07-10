function y=flipud(x)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global globp;

y.val=flipud(x.val);
[m,n] = size(x.val);

if m == 1   % x.val is a row vector;
    y.deriv = x.deriv;
elseif n == 1 % x.val is a column vector
    y.deriv = flipud(x.deriv);
else % x.val is a matrix
    for i = 1 : globp
        y.deriv(:,:,i)=flipud(x.deriv(:,:,i));
    end
end

y=class(y,'deriv');
