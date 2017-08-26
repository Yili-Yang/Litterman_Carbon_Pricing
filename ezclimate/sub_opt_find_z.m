
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
% sub_opt_m: suboptimal strategy (imported from a mat file for example)
% opt_m: optimial strategy at the initial point(imported from a mat file for example)
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
%function [z,fmin_m,,fcount_m,sub_opt_find_z
multiprocessing_setup()
%sub_opt_m = ones(1,59);
%sub_opt_m = [0,0,0,0,sub_opt_m];
%opt_m = ones(1,63);
load('subopt_opt_01')
z = 0;
pyclass = py.Matlabmod.matlabmode(-1);
diff =2;
iter_count = 0;
fcount_m = [];
iter_QN_m = [];
fmin_m =[];
z_m = [];
norm_g_m =[];
opt_m_r =[];
profile on
fun = @matlab_utility_g_sub_optimal_case2;
target = matlab_utility(sub_opt_m',pyclass);
while (norm(diff) > 1e-5)
    obj_function = @(z)(-cons_search(z,opt_m,pyclass) + target)^2;
    z = fminbnd(obj_function,-1,0);
    z_m = [z_m;z];
    opt_m_r = [opt_m_r;opt_m];
    [fmin,opt_m_new,fcount,~,iter] = Quasi_Newton(fun,opt_m',z,pyclass);
    fmin_m = [fmin_m;fmin];
    fcount_m = [fcount_m;fcount];
    iter_QN_m = [iter_QN_m;iter];
    [~,g] = matlab_utility_g_sub_optimal_case2(opt_m_new,z,pyclass);
    norm_g_m = [norm_g_m;norm(g)];
    diff = opt_m_new-opt_m';
    opt_m = opt_m_new';
    disp('diff')
    disp(norm(diff))
    iter_count = iter_count + 1;
end
profile off
profsave(profile('info'),'sub_opt_case2_info_1_01')
save('sub_opt_case2_test1_01')
%end

