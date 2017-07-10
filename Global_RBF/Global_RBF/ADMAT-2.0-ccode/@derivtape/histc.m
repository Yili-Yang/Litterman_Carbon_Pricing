function [n,bin] = histc(x, edge, dim)
%
%  [n,bin] = histc(varargin)
%
%  Histogram count
%
%  Returns the number of histogram count and an index matrix bin
%  If x is a vector, n(k) = sum(bin==k). bin is zero for out of range values. 
%  x is an M-by-N matrix, then, 
%      for j=1:N, n(k,j) = sum(bin(:,j)==k); end
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

%
if (nargin == 1)
    error('At least two input arguments are required.');
elseif (nargin == 2);
    input = 2;
elseif (nargin == 3)
    input = 3;
end

if (nargout == 1)
    out = 1;
else
    out = 2;
end

if (input == 2)
    if (out == 1)
        n = histc(getval(x), getval(edge));
    else
        [n, bin] = histc(getval(x), getval(edge));
    end
else
    if(out == 1)
        n = histc(getval(x), getval(edge), getval(dim));
    else
        [n, bin] = histc(getval(x), getval(edge), getval(dim));
    end
end
