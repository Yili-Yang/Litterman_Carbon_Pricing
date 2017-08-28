%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%           Yili Yang, July 2017
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Change the parameters in damage function and cost function and use random
% start point and Quasi-Newton method to find the local optimal point with
% mitigation at period 0 set to a const.
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
% mitigation_0: mitigation level at period 0 which will be fixed.
%
% Output:
% fmin2: final optimal object value (utility + positive add up)
% xmin2: final optimal mititgation point
% fcount2: function evaluation in this optimization process
% iter: iteration number of the optimization process
% final_norm_g_QN: the norm of gradient at the final optimal point.
% price: the optimal price (SCC) achieved by the final mitigation level.
% utility_at_each_node: final optimal utiltiy at each node.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [fmin2,xmin2,fcount2,iter,final_norm_g_QN,price,parameters,utlity_at_each_node] = find_sub_optimal(ind,mitigation_0,sampleind,pos)

multiprocessing_setup();
%end
pyclass = py.Matlabmod.matlabmode(ind);
%%%have to make sure it is optimial.
size_pos = size(pos);
n_col = size_pos(2);
m_in_mat_0 = rand(1,63-n_col)';
fun = @matlab_utility_g_sub_optimal;
[fmin2,xmin2,fcount2,~,iter] = Quasi_Newton(fun,m_in_mat_0,mitigation_0,pos,pyclass);% run Quasi_Newton loacl optimizer
[~,fg] = fun(xmin2,mitigation_0,pos,pyclass);
final_norm_g_QN = norm(fg);
t_size = size(pos);
for index = 1:t_size(2)
    pos(index) = pos(index) + index;
end
for index = 1:length(pos)
    xmin2 = [xmin2(1:(pos(index)-1),1)' mitigation_0(index) xmin2((pos(index)):end,1)']';
end
price = -double(py.array.array('d',py.numpy.nditer(py.Matlabmod.get_price(xmin2',pyclass))))';
parameters = -double(py.array.array('d',py.numpy.nditer(py.Matlabmod.get_parameters(pyclass))))';
utlity_at_each_node = -double(py.array.array('d',py.numpy.nditer(py.Matlabmod.get_utility_tree(xmin2',pyclass))))';

save(['sub_opt_of_index_','',num2str(ind),'','_test_','',num2str(sampleind),'','_with_mitigation_','',num2str(mitigation_0*100),'','_position_',mat2str(pos)
])
end
