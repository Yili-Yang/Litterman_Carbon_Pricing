clear all; clc;
startup;

dt = 0.1; dx = 0.05; delta = dt/dx^2;
T = 1; N = T/dt;
L = 1; M = L/dx;
[c, u0, uT] = prepareTestCaseHeat(M,N);

clear DM;
DM.M = M;
DM.N = N;
DM.u0 = u0;
DM.uT = uT;

varargin = DM;
m = 2;
x = randn(2,3*M);
dim = 3*M;

x = rand(2,60);
x1 = x(1,:);
f = heatfunValue(x1,DM)
[fad,gad] = heatfunAD(x1,DM)