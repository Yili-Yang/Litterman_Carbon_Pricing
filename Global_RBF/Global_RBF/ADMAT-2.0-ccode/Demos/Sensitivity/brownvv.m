function f = brownvv(x,V)
%BROWNVV Nonlinear minimization with dense structured Hessian
% F = BROWNVV(X,V) computes objective function F,
global globp
n=length(x); 
if isa(x, 'deriv') || isa(V, 'deriv')
    n = deriv(n);
end
  y=zeros(n,1);
  i=1:(n-1);
  y(i)=(x(i).^2).^(V*x(i+1).^2+1)+((x(i+1)+0.25).^2).^(x(i).^2+1) + (x(i)+0.2*V).^2;
  f = sum(y);
%   tmp = V'*x; 
%   f = f - .5*tmp'*tmp;
