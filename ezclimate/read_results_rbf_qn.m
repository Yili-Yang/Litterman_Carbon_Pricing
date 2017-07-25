file_name = 'RBF_QN_'; 
number = 'How manys files need to be read?';
file_name = input(file_name,'s');
number = input(number);
utility_after_rbf = [];
utility_after_qn = [];
final_norm_grad_gs = [];
final_norm_grad_qn = [];
num_iter_qn = [];
num_iter_rbf = [];
num_of_utility_ = [];
num_of_grad_qn = [];
final_value = [];
m = [];
for x = 1:number
    load([file, '', num2str(x), '', '.mat']);
    utility_after_rbf(end+1) = utility_RBF;
    utility_after_qn(end+1) = xmin1;
    final_norm_grad_gs(end+1) = final_norm_g_GS;
    final_norm_grad_qn(end+1) = final_norm_g_QN;
    num_iter_qn(end+1) = iter;
    num_iter_rbf(end+1) = iter1;
    num_of_utility(end+1) = fcount2;
    num_of_grad_qn(end+1) = fcount2;
    final_value(end+1) = fmin2;
    m = [m, m_gs];
end
 results = table;
 results.No = [1:number]';
 results.utility_after_ga = utility_after_ga';
 results.norm_after_ga = norm_after_ga';
 results.norm_after_rbf = norm_after_rbf';
 results.final_norm_grad_gs = final_norm_grad_gs';
 results.final_norm_grad_qn = final_norm_grad_qn';
 results.num_of_utility = num_of_utility';
 results.num_of_grad_qn = num_of_grad_qn';
 results.final_value = final_value';
 summary(results)
 error_of_fin_diff = std(final_value);
 
 mean_of_node = mean(m,2);
 std_of_node = std(m,1,2);
 
 save(['results_','',file_name],'','.mat');