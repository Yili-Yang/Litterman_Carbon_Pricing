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
    m_size = size(price_m);
    col = m_size(2);
    for ind = 1:col
        if price_m(:,ind)<0
            price_summary = [price_summary, price_m(:,ind)];
            final_norm_g_QN_summary = [final_norm_g_QN_summary; final_norm_g_QN_m(ind)];
            utility_node_summary = [utility_node_summary, utility_each_node_m(:,ind)];
            utility_summary = [utility_summary; fmin2_m(ind)];
            mitigation_summary = [mitigation_summary, xmin2_m(:,ind)];
            iteration_summary = [iteration_summary; iter_m(ind)];
            fcount_summary = [fcount_summary; fcount2_m(ind)];
        end
    end
    file = input('What is the name of the result file? ','s');
end
param = input('What is the number of the parameter in control? ');
save(['sensitivity_result_','',num2str(param)]);