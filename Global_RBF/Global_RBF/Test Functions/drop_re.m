function y = drop_re(xx,varargin)

x1 = xx(1);
x2 = xx(2);


frac1 = 1 + cos(12*sqrt(x1^2+x2^2));
frac2 = 0.5*(x1^2+x2^2) + 2;

y = -frac1/frac2;


end
