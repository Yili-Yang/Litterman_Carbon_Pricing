function value = cragglev(x,Extra)
%
% Evaluates the CRAGGLEVY test problem, described in ??.
%
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input:
%       x - the current point (column vector).
%
% Output:
%        value - (scalar) objective function value at x.
%         grad - gradient of the objective fcn. (column vector) evaluated at x.
%         H    -  Hessian (sparse symmetric matrix).
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Evaluate the function.
n=length(x); 
y=zeros(n,1);
n = getval(n);
if (rem(n,4)>0)
    error('  For this problem, n must be a multiple of 4.')
end
i=1:4:(n-3);
y(i)=(exp(x(i))-x(i+1)).^2+(x(i+1)-x(i+2)).^2+(tan(x(i+2)-x(i+3))).^2+x(i).^2+(x(i+3)-1).^2;

value=sum(y);