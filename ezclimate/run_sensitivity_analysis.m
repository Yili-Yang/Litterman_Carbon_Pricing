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
% sample_count: the number of samples that you want to run
% Output:
% fmin2_m: final optimal object value (utility + positive add up) in each
% sample
% xmin2_m: final optimal mititgation point in each test
% fcount2_m: function evaluation in this optimization process in each sample
% iter_m: iteration number of the optimization process in each sample
% final_norm_g_QN_m: the norm of gradient at the final optimal poin in each
% sample
% price_m: the optimal price (SCC) achieved by the final mitigation level
% in each sample
% utility_at_each_node_m: final optimal utiltiy at each node in each sample
% parameters_m: parameters used to generate damage or cost in each sample
% total_time_m: profiler time consumed in each sample
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ind = 4;
sample_count = 30;
fmin2_m = [];
xmin2_m = [];
fcount2_m = [];
iter_m = [];
final_norm_g_QN_m = [];
price_m = [];
parameters_m = [];
total_time_m = [];
utility_each_node_m=[];
multiprocessing_setup;
for count = 1:sample_count
    profile on 
    [fmin2,xmin2,fcount2,iter,final_norm_g_QN,price,parameters,utlity_at_each_node] = sensitivity_analysis(ind);
    fmin2_m = [fmin2_m;fmin2];
    xmin2_m = [xmin2_m,xmin2];
    fcount2_m =[fcount2_m;fcount2];
    iter_m = [iter_m;iter];
    final_norm_g_QN_m = [final_norm_g_QN_m;final_norm_g_QN];
    price_m = [price_m,price];
    parameters_m =[parameters_m,parameters];
    utility_each_node_m =[utility_each_node_m,utlity_at_each_node];
    profile off
    total_timer = profile('info');
    sample_time = total_timer.FunctionTable.TotalTime;
    total_time_m = [total_time_m;total_timer];
end

save(['sensitivity_base/sensitivity_','',num2str(ind+1),'_',num2str(sample_count)])
profsave(profile('info'),['sensitivity_base/sensitivity_','',num2str(ind+1),'_',num2str(sample_count),'_profiler'])