%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Xin(Keira) Shu, August 2017
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% read the sensitivity test results for a particular parameter and 
% summarize the variables in concern
% input:
% 1. name of the test result files (press ENTER when nothing is left to read)
% 2. the parameter number of the sensitivity tests
% file saved:
% 'sensitivity_results_(parameter number)'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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