function out=isinf(x)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


% [m,n] = size(x.val);
% if m == 1 && n ==1  % x.val is a scalar
%     out = isinf(x.val) & any(isinf(x.deriv));
% elseif m == 1  % x.val is a row vector
%     out = isinf(x.val) & sum(isinf(x.deriv), 2)';
% elseif n == 1 % x.val is a column vector
%     out = isinf(x.val) & sum(isinf(x.deriv),2);
% else   % x.val is a matrix
%     out = isinf(x.val) & sum(isinf(x.deriv), 3);
% end
out=isinf(x.val);