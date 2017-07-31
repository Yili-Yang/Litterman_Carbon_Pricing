price_m_t = [];
utility = [];
norm_g = [];
iteration = [];
load('sensitivity_base/sensitivity_base_6.mat')
price_m_t = [price_m_t,price_m];
utility = [utility; fmin2_m];
norm_g = [norm_g; final_norm_g_QN_m];
iteration = [iteration; iter_m];
load('sensitivity_base/sensitivity_base_8.mat')
price_m_t = [price_m_t,price_m];
utility = [utility; fmin2_m];
norm_g = [norm_g; final_norm_g_QN_m];
iteration = [iteration; iter_m];
load('sensitivity_base/sensitivity_base_16.mat')
price_m_t = [price_m_t,price_m];
utility = [utility; fmin2_m];
norm_g = [norm_g; final_norm_g_QN_m];
iteration = [iteration; iter_m];
utility = utility([1:12 14:end]);
norm_g = norm_g([1:12 14:end]);
iteration = iteration([1:12 14:end]);
std_u = std(utility);