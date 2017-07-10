clear all; clc;

dt = 0.1;
dx = 0.05;
delta = dt/dx^2;
K = 0.5;
T = 1;
N = T/dt;
L = 1;
M = L/dx;

C1 = num2cell(rand(3*M,N),1)';

D = cell2mat(C1);

C2 = num2cell(D,1);

bool = isequal(C1, C2)