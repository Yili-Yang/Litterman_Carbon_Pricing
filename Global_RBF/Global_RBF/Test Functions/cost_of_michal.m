function [y,g,H] = michal(xx, varargin)

mm = 10;
d = length(xx);
sum = 0;
g=zeros(d,1);
H=zeros(d);

for ii = 1:d
	xi = xx(ii);
	new = sin(xi) * (sin(ii*xi^2/pi))^(2*mm);
	sum  = sum + new;
end

y = -sum;

[fc, gc] = fcost(xx);
% w = y/fc;
w = 1;
fc = w*fc;
gc = w*gc;
y = fc+y;

if (nargout >= 2)
    for i=1:d
        xi = xx(i);
        g(i,1) = -cos(xi)*(sin(i*xi^2/pi))^(2*mm)...
            -4*mm*i*xi/pi*sin(xi)*(sin(i*xi^2/pi))^(2*mm-1)*cos(i*xi^2/pi);
    end
    g = gc+g;
end

if (nargout == 3)
    
    for i=1:d
        sinii=sin(i*xi^2/pi);
        cosii=cos(i*xi^2/pi);
        H(i,i)=sin(xi)*sinii^(2*mm)-4*mm*i*xi/pi*cos(xi)*sinii^(2*mm-1)*cosii...
            -4*mm*i*xi/pi*(sin(xi)+xi*cos(xi))*sinii^(2*mm-1)*cosii...
            -8*mm*(i*xi/pi)^2*sin(xi)*((2*mm-1)*sinii^(2*mm-2)*cosii^2-sinii^(2*mm));
    end
end
end