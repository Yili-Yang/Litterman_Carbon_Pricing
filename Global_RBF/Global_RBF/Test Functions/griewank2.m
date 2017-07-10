function [f,g,H] = griewank2(x, varargin)
% add two terms of x(1)/10+x(2)/10 for the original griewank function.

f = 1 + x(1)*x(1)/200 + x(2)*x(2)/200 - cos(x(1))*cos(x(2)/sqrt(2))+...
    x(1)/10+x(2)/10;
if (nargout >= 2)
g(1,1) = x(1)/100 + sin(x(1))*cos(x(2)/sqrt(2))+1/10;
g(2,1) = x(2)/100 + cos(x(1))*sin(x(2)/sqrt(2))/sqrt(2)+1/10;
end

if (nargout == 3)
H(1,1) = 1/100 + cos(x(1))*cos(x(2)/sqrt(2));
H(2,1) = -sin(x(1))*sin(x(2)/sqrt(2))/sqrt(2);
H(1,2) = H(2,1);
H(2,2) = 1/100 + cos(x(1))*cos(x(2)/sqrt(2))/2;
end

end