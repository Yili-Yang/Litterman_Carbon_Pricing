file_name = 'GA_GS_QN_'; 
number = 'How manys files need to be read?';
number = input(number);
utility_after_ga = [];
norm_after_ga = [];
final_norm_grad_gs = [];
final_norm_grad_qn = [];
num_of_utility = [];
num_of_grad_qn = [];
final_value = [];
m = [];
for x = 1:number
    load([file_name, '', num2str(x), '', '.mat']);
    utility_after_ga(end+1) = utlity_GA;
    norm_after_ga(end+1) = norm_g_GA;
    final_norm_grad_gs(end+1) = final_norm_g_GS;
    final_norm_grad_qn(end+1) = final_norm_g_QN;
    num_of_utility(end+1) = fcount2;
    num_of_grad_qn(end+1) = fcount2;
    final_value(end+1) = fmin2;
    m = [m, xmin2'];
end
 results = table;
 results.No = [1:number]';
 results.utility_after_ga = utility_after_ga';
 results.norm_after_ga = norm_after_ga';
 results.final_norm_grad_gs = final_norm_grad_gs';
 results.final_norm_grad_qn = final_norm_grad_qn';
 results.num_of_utility = num_of_utility';
 results.num_of_grad_qn = num_of_grad_qn';
 results.final_value = final_value';
 
 error_of_fin_diff = std(final_value);
 utility_after_ga = mean(utility_after_ga);
 norm_after_ga = mean(norm_after_ga);
 final_norm_grad_gs = mean(final_norm_grad_gs);
 final_norm_grad_qn = mean(final_norm_grad_qn);
 num_of_utility = mean(num_of_utility);
 num_of_grad_qn = mean(num_of_grad_qn);
 final_value = mean(final_value);
 
 mean_of_node = mean(m,2);
 std_of_node = std(m,1,2);
 
 save(['results_','',file_name]);