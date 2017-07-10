function [y,g,H] = booth(x,varargin)
% 
% Booth function 
% Matlab Code by A. Hedar (Sep. 29, 2005).
% The number of variables n = 2.
% 
y  = (x(1)+2*x(2)-7)^2+(2*x(1)+x(2)-5)^2;

[fc, gc] = fcost(x);
w = y/fc;
fc = w*fc;
gc = w*gc;
y = fc+y;

g=zeros(2,1);
H=zeros(2);

if (nargout >= 2)
    g(1)=2*(x(1)+2*x(2)-7)+4*(2*x(1)+x(2)-5);
    g(2)=4*(x(1)+2*x(2)-7)+2*(2*x(1)+x(2)-5);
    g = gc+g;
end
if (nargout == 3)
    H(1,1) = 16;
    H(2,1)=8;
    H(1,2)=8;
    H(2,2)=10;
end