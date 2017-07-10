function f = schaffer ( x, varargin )
a=cos(sin(abs(x(1)^2-x(2)^2)))-0.5;
b=(1+0.001*(x(1)^2+x(2)^2))^2;
f=0.5+a/b;
end