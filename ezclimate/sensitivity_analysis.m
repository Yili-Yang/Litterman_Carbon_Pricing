%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%           Yili Yang, July 2017
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Change the parameters in damage function and cost function and use random
% start point and Quasi-Newton method to find the local optimal point.
%
% Input:
% ind: the indicator of what parameters is been changed.
%   1. = -1: use original parameters and fixed seed to simulate damage 
%   2. = 0~8: change the parameters in pindyck damage simulation, 0 is to 
%             change alpha450, 1 is to change alpha650 ... 8 is to change
%             theta1000
%   3. = 9: use orignal parameters and random seed to simulate damage
%   4. = 10 or 11: change the parameters in cost function, 10 is to change
%                  x60 and 11 is to change x100
% Output:
% fmin2: final optimal object value (utility + positive add up)
% xmin2: final optimal mititgation point
% fcount2: function evaluation in this optimization process
% iter: iteration number of the optimization process
% final_norm_g_QN: the norm of gradient at the final optimal point.
% price: the optimal price (SCC) achieved by the final mitigation level.
% utility_at_each_node: final optimal utiltiy at each node.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [fmin2,xmin2,fcount2,iter,final_norm_g_QN,price,parameters,utlity_at_each_node] = sensitivity_analysis(ind)

varargin = py.Matlabmod.matlabmode(ind); % init the class in Matlabmode_g
%%%have to make sure it is optimial.
m_in_mat_0 = rand(1,63)';
fun = @matlab_utility_g_multiprocessing;
[fmin2,xmin2,fcount2,~,iter] = Quasi_Newton(fun,m_in_mat_0,varargin);% run Quasi_Newton loacl optimizer
[~,fg] = fun(xmin2,varargin);
final_norm_g_QN = norm(fg);
price = -double(py.array.array('d',py.numpy.nditer(py.Matlabmod.get_price(xmin2',varargin))))';
parameters = -double(py.array.array('d',py.numpy.nditer(py.Matlabmod.get_parameters(varargin))))';
utlity_at_each_node = -double(py.array.array('d',py.numpy.nditer(py.Matlabmod.get_utility_tree(xmin2',varargin))))';
end
