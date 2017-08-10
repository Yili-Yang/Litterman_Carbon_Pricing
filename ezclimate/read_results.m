file = input('What is the name of the result file? ','s');
load(file);
price_summary = [];
final_norm_g_QN_summary = [];
utility_node_summary = [];
utility_summary = [];
mitigation_summary = [];
iteration_summary = [];
fcount_summary = [];
while ~isempty(file)
    load(file);
    price_summary = [price_summary, price_m];
    final_norm_g_QN_summary = [final_norm_g_QN_summary; final_norm_g_QN_m];
    utility_node_summary = [utility_node_summary, utility_each_node_m];
    utility_summary = [utility_summary; fmin2_m];
    mitigation_summary = [mitigation_summary, xmin2_m];
    iteration_summary = [iteration_summary; iter_m];
    fcount_summary = [fcount_summary; fcount2_m];
    file = input('What is the name of the result file? ','s');
end
param = input('What is the number of the parameter in control? ');
save(['sensitivity_result_','',num2str(param)]);