load('sensitivity_base/sensitivity_base_6.mat')
price_m_t = [];
utility = [];
price_m_t = [price_m_t,price_m];
utility = [utility; fmin2_m];
load('sensitivity_base/sensitivity_base_8.mat')
price_m_t = [price_m_t,price_m];
utility = [utility; fmin2_m];
load('sensitivity_base/sensitivity_base_16.mat')
price_m_t = [price_m_t,price_m];
utility = [utility; fmin2_m];
utility = utility([1:12 14:end]);
std_u = std(utility);