ind = 9;
fmin2_m = [];
xmin2_m = [];
fcount2_m = [];
iter_m = [];
final_norm_g_QN_m = [];
price_m = [];
parameters_m = [];
profile on 
for count = 1:6
    [fmin2,xmin2,fcount2,iter,final_norm_g_QN,price,parameters] = sensitivity_analysis(ind);
    fmin2_m = [fmin2_m;fmin2];
    xmin2_m = [xmin2_m,xmin2];
    fcount2_m =[fcount2_m;fcount2];
    iter_m = [iter_m;iter];
    final_norm_g_QN_m = [final_norm_g_QN_m;final_norm_g_QN];
    price_m = [price_m,price];
    parameters_m =[parameters_m,parameters];
end
profile off
save('sensitivity_base/sensitivity_base_6')
profsave(profile('info'),'sensitivity_base/sensitivity_base_6_profiler')