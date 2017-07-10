function f= arrowfun(x,Extra)

f=x.*x;
f(1)=f(1)+x'*x;
f=f+x(1)*x(1);
