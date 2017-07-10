function f = brownv(x,V)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% BROWNV Nonlinear minimization with dense structured Hessian
% 
% Input
%     x -- The current point (column vector). When it is an
%          object of deriv class, the fundamental operations
%          will be overloaded automatically.
%     V -- Parameter of the function.
%
% Output
%     f -- Function value.
%
%                 Wei Xu
%                Oct. 2008
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% length of input x
n=length(x); 
% if any input is a 'deriv' class object, set n to 'deriv' class as
% well, so that the initial vector y can be set up as a 'deriv' object,
% too.
if isa(x, 'deriv') || isa(V, 'deriv')
    n = deriv(n);
end
y=zeros(n,1);
i=1:(n-1);
y(i)=(x(i).^2).^(V*x(i+1).^2+1)+((x(i+1)+0.25).^2).^(x(i).^2+1) + (x(i)+0.2*V).^2;
f = sum(y);
tmp = V'*x; 
f = f - .5*tmp'*tmp;
