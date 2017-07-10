function [f, g, H] = example4(x,varargin)
% This example is from the Numerical Optimization book's exercise 4.3.

n=length(x)/2;
f=0;
g=zeros(2*n,1);
H=zeros(2*n);

for i=1:n
    f=f+(1-x(2*i-1))^2+10*(x(2*i)-x(2*i-1)^2)^2;
    if (nargout >= 2)
    g(2*i-1)=-2*(1-x(2*i-1))-40*(x(2*i)-x(2*i-1)^2)*x(2*i-1);
    g(2*i)=20*(x(i*2)-x(2*i-1)^2);
    end
    if (nargout == 3)
    H(2*i-1,2*i-1)=2-40*(x(2*i)-x(2*i-1)^2)+80*x(2*i-1)^2;
    H(2*i-1,2*i)=-40*x(2*i-1);
    H(2*i,2*i-1)=H(2*i-1,2*i);
    H(2*i,2*i)=20;
    end
end
    