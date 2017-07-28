file_name = 'RBF_100.mat';
load(file_name);
utility_after_RBF = mean(u_matrix_RBF);
std_u_RBF = std(u_matrix_RBF);
save(['results_','', file_name]);
