price_m_t = [];
mitigation = [];
utility = [];
norm_g = [];
iteration = [];
iteration_u = [];
load('sensitivity_base/sensitivity_base_6.mat')
price_m_t = [price_m_t, price_m];
mitigation = [mitigation, xmin2_m];
utility = [utility; fmin2_m];
norm_g = [norm_g; final_norm_g_QN_m];
iteration = [iteration; iter_m];
iteration_u = [iteration_u; fcount2_m];
load('sensitivity_base/sensitivity_base_8.mat')
price_m_t = [price_m_t,price_m];
mitigation = [mitigation, xmin2_m];
utility = [utility; fmin2_m];
norm_g = [norm_g; final_norm_g_QN_m];
iteration = [iteration; iter_m];
iteration_u = [iteration_u; fcount2_m];
load('sensitivity_base/sensitivity_base_16.mat')
price_m_t = [price_m_t,price_m];
mitigation = [mitigation, xmin2_m];
utility = [utility; fmin2_m];
norm_g = [norm_g; final_norm_g_QN_m];
iteration = [iteration; iter_m];
price_m_t = price_m_t(:,[1:12 14:end]);
utility = utility([1:12 14:end]);
norm_g = norm_g([1:12 14:end]);
iteration = iteration([1:12 14:end]);
iteration_u = [iteration_u; fcount2_m];
mitigation = mitigation(:,[1:12 14:end]);
std_u = std(utility);
save('sensitivity_base_results');