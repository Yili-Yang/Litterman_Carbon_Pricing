function [f, g, H] = examplenew(x, varargin)
% example from CGO

f = 1 + sin(x(1)*x(1)) + sin(x(2)*x(2)) - 0.1*exp(-x(1)*x(1)-x(2)*x(2));
if (nargout >= 2)
g(1,1) = cos(x(1)*x(1))*2*x(1) + 0.2*x(1)*exp(-x(1)*x(1)-x(2)*x(2));
g(2,1) = cos(x(2)*x(2))*2*x(2) + 0.2*x(2)*exp(-x(1)*x(1)-x(2)*x(2));
end
if (nargout == 3)
H(1,1) = -4*x(1)*x(1)*sin(x(1)*x(1)) + 2*cos(x(1)*x(1)) + ...
    0.2*exp(-x(1)*x(1)-x(2)*x(2)) - 0.4*x(1)*x(1)*exp(-x(1)*x(1)-x(2)*x(2));
H(2,1) = -0.4*x(1)*x(2)*exp(-x(1)*x(1)-x(2)*x(2));
H(1,2) = H(2,1);
H(2,2) = -4*x(2)*x(2)*sin(x(2)*x(2)) + 2*cos(x(2)*x(2)) + ...
    0.2*exp(-x(1)*x(1)-x(2)*x(2)) - 0.4*x(2)*x(2)*exp(-x(1)*x(1)-x(2)*x(2));
end
end