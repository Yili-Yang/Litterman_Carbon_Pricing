function [y,g,H] = levy13(xx,varargin)

x1 = xx(1);
x2 = xx(2);

term1 = (sin(3*pi*x1))^2;
term2 = (x1-1)^2 * (1+(sin(3*pi*x2))^2);
term3 = (x2-1)^2 * (1+(sin(2*pi*x2))^2);

y = term1 + term2 + term3;

if (nargout >= 2)
     g=zeros(2,1);
    g(1,1) =6*pi*sin(3*pi*x1)*cos(3*pi*x1)+2*(x1-1)*(1+(sin(3*pi*x2))^2);
    g(2,1) = (x1-1)^2 * 6*pi*sin(3*pi*x2)*cos(3*pi*x2)+2*(x2-1)*(1+(sin(2*pi*x2))^2)...
    +4*pi*(x2-1)^2*sin(2*pi*x2)*cos(2*pi*x2);
end
if (nargout == 3)
    H=zeros(2);
H(1,1) = cos(6*pi*x1)*18*pi^2+2*(1+(sin(3*pi*x2))^2);
H(2,1) = 2*(x1-1)*3*pi*sin(6*pi*x2);
H(1,2) = H(2,1);
H(2,2) = (x1-1)^2 *18*pi^2*cos(6*pi*x2)+2*(1+(sin(2*pi*x2))^2)...
    +4*pi*(x2-1)*sin(4*pi*x2)+4*pi*(x2-1)*sin(4*pi*x2)...
    +8*pi^2*(x2-1)^2*cos(4*pi*x2);
end
end