%% some test script
clear all; clc;
startup;

M = 10;
[x, uT, A, b0] = prepareTestCase(M);
B = inv(A);

clear DM;
DM.B = B;
DM.uT = uT;
varargin = DM;

[fa, ga] = Dirichletfun(x,DM)
[fd, gd] = DirichletfunAD(x,DM)