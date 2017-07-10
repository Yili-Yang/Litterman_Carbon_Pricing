function [f,g,H] = example2(x)
f=x*x-cos(18*x);
g=2*x+18*sin(18*x);
H=2+18*18*cos(18*x);
end