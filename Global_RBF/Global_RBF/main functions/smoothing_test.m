close all;
clear all;
clc;
startup;

prob1 = 1;
prob2 = 25;

for i = 1:1
    [Random_Case] = run_global_RBF_TRM(prob1,prob2,1,0)
    [Random_Cost] = run_global_RBF_TRM_cost(prob1,prob2,1,0)
end