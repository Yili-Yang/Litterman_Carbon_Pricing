function [z,grad] = gradientst(functions, x, dependency, Extra)
% requires ADMAT methods: jacobianst
% - - - - - - - - - - - - - - - - - - - - - - - - -
% gradientst computes the gradient of the computation
% z - output of the computation
% grad - the gradient
% functions - cell array of function names of each step of the computation
%               the last name should correspond to a scalar function
% x - vector of initial input
% dependency - N-by-2 cell array of dependecy information of the steps of the computation
% Extra - optional structure containing any user defined parameter required by the computation

[z,grad] = jacobianst(functions, x, dependency, Extra);