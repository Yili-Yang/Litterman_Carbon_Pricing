function [y,g,H] = ackley(x,extra)
% 
% Ackley function.
% Matlab Code by A. Hedar (Sep. 29, 2005).
% The number of variables n should be adjusted below.
% The default value of n =2.
% 
n = length(x);
a = 20; b = 0.2; c = 2*pi;
s1 = 0; s2 = 0;
for i=1:n;
   s1 = s1+x(i)^2;
   s2 = s2+cos(c*x(i));
end
y = -a*exp(-b*sqrt(1/n*s1))-exp(1/n*s2)+a+exp(1);

g=zeros(n,1);
H=zeros(n);
for i=1:n
    if (nargout >= 2)
        g(i)=-a*exp(-b*sqrt(1/n*s1))*(-b/n*x(i)*(s1/n)^(-1/2))...
            -exp(1/n*s2)*(-1/n*2*pi*sin(c*x(i)));
    end
    if (nargout == 3)
        H(i,i)=-a*exp(-b*sqrt(1/n*s1))*...
            ((-b/n*x(i)*(s1/n)^(-1/2))^2+b/4*(s1/n)^(-3/2)*(1/n*2*x(i))^2-b/n*(s1/n)^(-1/2))...
            -exp(1/n*s2)*((-1/n*2*pi*sin(c*x(i)))^2+(-1/n*c^2*cos(c*x(i))));
        
    end
end