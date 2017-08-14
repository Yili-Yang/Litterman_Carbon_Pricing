%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%           Yili Yang, July 2017
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Using Genetic Algorithm to find the start point and then us Quasi-Newton
% method as the local optimizer to get the optimal mitigation level on each
% node
%
% Input:
% m_in_mat: mitigation level stored in matlab double
% instance of matlabmode class in Matlabmod (Provide damage simualtion and utility)
%
% Output:
% re - objective function value: 
%     1. utility + positive modification term if utility is calculated by python
%     2. positive modification term if utility is not calculate by python 
% g - gradient of the utility 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [fmin2,xmin2,fcount2,iter,final_norm_g_QN,price,parameters,utlity_at_each_node] = sensitivity_analysis(ind)
multiprocessing_setup() % set up multiprocessing package, manully call the exectuable of python
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
