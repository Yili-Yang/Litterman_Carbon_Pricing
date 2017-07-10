function [x, fval, it] = newton_expand(func, func_y, funG, x0, p, tol, itNum, Extra)
%
% implement the Newton method on 'func'. It stops when the function value 
% reaches the tolerance 'tol' or iteration reaches the iteration limit
% 'numIt'. If the input function 'func' is a structured function (p~=0),
% we will check the number of intermediate variables. If the number is too 
% large, absorb some of them. It is hard to determine the optimal num_int 
% in theory, but according to some experiements, num_int = 4 or 5 is the 
% best. Here, we take int_num = 4.
%
% INPUT
%   func -- expanded function for Newton method
%   func_y -- reveal the relationship between x and intermediate varibles
%             y1,....,yp
%     funG -- G(x) on the right hand side of expanded Newton process.
%     x0 -- initial value of x
%    tol -- tolerance of 'func' value
%  itNum -- Newton step limit
%  Extra -- parameters for function 'func'
%      p -- number of intermediate variables
%
% OUTPUT
%      x -- root of nonlinear function 'func'
%   fval -- function value at x
%
%
if nargin < 4
    error(' At least 4 input argumemnts are required!');
end

switch (nargin)
    case 4 
        p = 1;
        tol = 1e-6;
        itNum = 50;
        Extra = [];
    case 5
        tol = 1e-6;
        itNum = 50;
        Extra = [];
    case 6
        itNum = 50;
        Extra = [];
    case 7
        Extra = [];
    otherwise
end

x = x0;
m = length(x0);  % size of x

% compute [x; y1; ...; yp] 
y = feval(func_y, x, Extra);
n = length(y);   % size of [x,y1,y2,...,yp]

mm = length(feval(func, y, Extra));
% initialize the number of iteration step
it = 0;
num_int = 20;
if isempty(Extra)
    % get the sparse sturcture of Jacobian matrix of func
    JPI = getjpi(func, mm);
else     % Extra is not empty    
    % get the sparse sturcture of Jacobian matrix of func
    JPI = getjpi(func, mm,[], Extra);
end

fval = 1;    

% Newton steps
while (abs(norm(fval)) > tol) && (it < itNum)
    % calculate the function value of G(x).
    fval = feval(funG, y, Extra);
    k = length(fval);
    % evaluate the functin value and the Jacobian matrix at [x,y1,...,yp]
    [z, J] = evalj(func, y, Extra, [],JPI);
    %
    % if number of intermediate variables is larger than num_int, the speed
    % of the structured Newton method is low since the overload on solving
    % a linear Newton system. Thus, we absorb some intermediate variables 
    % in order to decrease the size of the Newton system.
    %
    
    if p > num_int
        N = n/(p+1);    % size of original problem
        for i = p:-1: num_int
            D = J(i*N+1:(i+1)*N, i*N+1:(i+1)*N);
            B = J((i-1)*N+1:i*N, i*N+1:(i+1)*N);
            A = J((i-1)*N+1:i*N, 1:i*N);
            C = J(i*N+1:(i+1)*N, 1 :i*N);
            C = C-D*(B\A);
            J = sparse([J(1:(i-1)*N, 1:i*N); C]);
        end
        % construct right hand side of Newton system
        F = zeros(num_int*N,1);
        F(N*(num_int-1)+1 : num_int*N) = fval;
    else
        % construct right hand side of Newton system
        F = zeros(n,1);
        F(n-k+1 : n) = fval;
    end
    try
        delta = -slls(J,F);
    catch
        delta = -J\F;
    end
    x = x + delta(1:m);
    % compute [x; y1; ...; yp] 
    y = feval(func_y, x, Extra);
    it = it + 1;
end
