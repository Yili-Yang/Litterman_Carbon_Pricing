% scale-valued function
%
%      barF(x) = x1^2 + x2^2 + ... + x(n)^2 + 5*x1*x2 + 5*x2*x3 + ... +
%      5*xi*x(i+1) + ... + 5*x(n-1)*x(n) ,
% 
% where x = [x(1), x(2), ..., x(n)]. The Hessian matrix of barF(x) is symmetric
% tridiagonal.
%
function fval = barF(x, Extra)

y = Extra.y;
n = length(y);
i = 1 : (n-1);
z = x'*x + 5*x(i)'*x(i+1);

fval = z + y'*y;

    