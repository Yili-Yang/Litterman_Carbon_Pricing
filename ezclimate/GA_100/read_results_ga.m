file_name = 'GA_';
number = 'How many files need to be read?'
load([file_name,'',number,'','.mat']);
utility = [u_matrix_GA];
ave_utility = mean(utility);