function [y,g,H] = rast(x,varargin)
% 
% Rastrigin function
% Matlab Code by A. Hedar (Nov. 23, 2005).
% The number of variables n should be adjusted below.
% 

n = length(x); 
s = 0;


for j = 1:n
    s = s+x(j)^2-10*cos(2*pi*x(j)); 
end
y = 10*n+s;
if (nargout >= 2)
    g=zeros(n,1);
    for j=1:n
        g(j,1)=2*x(j)+20*pi*sin(2*pi*x(j));
    end
end
if (nargout == 3)
    H=zeros(n);
    for j=1:n
        H(j,j)=2+40*pi*pi*cos(2*pi*x(j));
    end
end

end