ind = 1;
sample_count = 100;
fmin2_m = [];
xmin2_m = [];
fcount2_m = [];
iter_m = [];
final_norm_g_QN_m = [];
price_m = [];
parameters_m = [];
total_time_m = [];
utility_each_node=[];
for count = 1:sample_count
    profile on 
    [fmin2,xmin2,fcount2,iter,final_norm_g_QN,price,parameters] = sensitivity_analysis(ind);
    fmin2_m = [fmin2_m;fmin2];
    xmin2_m = [xmin2_m,xmin2];
    fcount2_m =[fcount2_m;fcount2];
    iter_m = [iter_m;iter];
    final_norm_g_QN_m = [final_norm_g_QN_m;final_norm_g_QN];
    price_m = [price_m,price];
    parameters_m =[parameters_m,parameters];
    profile off
    total_timer = profile('info');
    sample_time = total_timer.FunctionTable.TotalTime;
    total_time_m = [total_time_m;sample_time];
end

save(['sensitivity_base/sensitivity_','',num2str(ind+1),'_',num2str(sample_count)])
profsave(profile('info'),['sensitivity_base/sensitivity_','',num2str(ind+1),'_',num2str(sample_count),'_profiler'])