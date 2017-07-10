function [y] = egg(xx,varargin)

x1 = xx(1);
x2 = xx(2);

term1 = -(x2+47) * sin(sqrt(abs(x2+x1/2+47)));
term2 = -x1 * sin(sqrt(abs(x1-(x2+47))));

y = term1 + term2;
end
