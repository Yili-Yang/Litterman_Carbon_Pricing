function [x, normy, it] = newton(func, x0, tol, itNum, Extra)
%
% implement the Newton method on 'func'. It stops when the function value 
% reaches the tolerance 'tol' or iteration reaches the iteration limit
% 'itNum'.
%
% INPUT
%   func -- function for Newton method
%     x0 -- initial value of x
%    tol -- tolerance of 'func' value
%  itNum -- Newton step limit
%  Extra -- parameters for function 'func'
%
% OUTPUT
%      x -- root of nonlinear function 'func'
%  normy -- norm of function value at x
%     it -- number of iterations
%
%
if (nargin < 2)
    error('At least two input arguments are required.');
end
switch (nargin)
    case 2
        tol = 1e-13;
        itNum = 100;
        Extra = [];
    case 3
        itNum = 100;
        Extra = [];
    case 4
        Extra = [];
    otherwise
end  

x = x0;
n = length(x0);
m = length(feval(str2func(func), x0));
% initialize the number of iteration step
it = 0;   

% call sparse Jaobian matrix computing function
if nargin < 5
    % get the sparse sturcture of Jacobian matrix of func
    JPI = getjpi(func,m);
else     % Extra is not empty
    JPI = getjpi(func, m,[], Extra);
end
normy = 1.0;

% Newton steps
while ( normy > tol) && (it < itNum)
    % evaluate the functin value and the Jacobian matrix at x
    [y, J] = evalj(func, x, Extra, [],JPI);
    if size(J,1) == size(J,2)   % if J is square, '\' is faster than slls
        delta = -J\y;
    else
        try
            delta = -slls(J,y);
        catch
            delta = -J\y;
        end
    end
    normy = norm(y);
    x = x + delta;
    it = it + 1;
end