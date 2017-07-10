clear all; clc;

n=5;
myfun=ADfun('broyden',n);
x=ones(n,1);
[F,J]=feval(myfun,x)