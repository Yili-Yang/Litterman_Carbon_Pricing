file_name = 'GA_'; %read the results
x = 'How many files need to be read?';
x = input(x);
load([file_name,'',num2str(x),'','.mat']);
utility = [u_matrix_GA];
ave_utility = mean(utility);
save(['results_','',file_name,'',num2str(x)]);