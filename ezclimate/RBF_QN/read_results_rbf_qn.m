file_name = 'RBF_QN'; 
number = 'How manys files need to be read?';
number = input(number);
utility_after_rbf = [];
utility_after_qn = [];
final_norm_grad_gs = [];
final_norm_grad_qn = [];
norm_grad_rbf = [];
num_iter_qn = [];
num_iter_rbf = [];
num_of_utility = [];
num_of_grad_qn = [];
final_value = [];
m = [];

for x = 1:number
    load([file_name, '', num2str(x), '', '.mat']);
    utility_after_rbf(end+1) = utlity_RBF;
    utility_after_qn(end+1) = fmin1;
    final_norm_grad_gs(end+1) = final_norm_g_GS;
    final_norm_grad_qn(end+1) = final_norm_g_QN;
    norm_grad_rbf(end+1) = norm_g_RBF;
    num_iter_qn(end+1) = iter;
    num_iter_rbf(end+1) = iter1;
    num_of_utility(end+1) = fcount2;
    num_of_grad_qn(end+1) = fcount2;
    final_value(end+1) = fmin2;
    m = [m, m_gs];
end
 results = table;
 results.No = [1:number]';
 results.utility_after_rbf = utility_after_rbf';
 results.utility_after_qn = utility_after_qn';
 results.norm_graf_rbf = norm_grad_rbf';
 results.final_norm_grad_gs = final_norm_grad_gs';
 results.final_norm_grad_qn = final_norm_grad_qn';
 results.num_iter_qn = num_iter_qn';
 results.num_iter_rbf = num_iter_rbf';
 results.num_of_utility = num_of_utility';
 results.num_of_grad_qn = num_of_grad_qn';
 results.final_value = final_value';
 
 error_of_fin_diff = std(final_value);
 utility_after_rbf = mean(utility_after_rbf);
 utility_after_qn = mean(utility_after_qn);
 norm_grad_rbf = mean(norm_grad_rbf);
 final_norm_grad_gs = mean(final_norm_grad_gs);
 final_norm_grad_qn = mean(final_norm_grad_qn);
 num_iter_qn = mean(num_iter_qn);
 num_iter_rbf = mean(num_iter_rbf);
 num_of_utility = mean(num_of_utility);
 num_of_grad_qn = mean(num_of_grad_qn);
 final_value = mean(final_value);
 
 mean_of_node = mean(m,2);
 std_of_node = std(m,1,2);
 
 save(['results_','',file_name]);