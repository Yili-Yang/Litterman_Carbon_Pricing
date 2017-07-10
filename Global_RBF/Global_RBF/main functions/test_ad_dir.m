clc; clear all;
startup;

M = 10;
[x,uT,A,b0] = prepareTestCase(M);
b0 = full(b0);
uT = full(uT);
A = full(A);
B = inv(A);

DM.B=B;
DM.uT=uT;
DM.M = M;

x = randn(4*M,1);

[f,g]=Dirichletfun(x,DM)

fva = DirichletfunValue(x,DM)

[fad,gad]= DirichletfunAD(x,DM)