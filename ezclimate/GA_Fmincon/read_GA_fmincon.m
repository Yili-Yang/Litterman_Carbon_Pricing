file_name = 'GA_fmincon_';
number = 'How manys files need to be read?';
number = input(number);
utility_ga = [];
norm_g_ga = [];
utility_fmincon = [];
norm_g_r = [];
utility_r = [];
iter = [];
count_utility = [];
m = [];

for x = 1:number
    load([file_name, '', num2str(x),'','.mat']);
    utility_ga(end+1) = utlity_GA;
    norm_g_ga(end+1) = norm_g_GA;
    utility_fmincon(end+1) = fval;
    norm_g_r(end+1) = norm_g_rand; 
    utility_r(end+1) = utility_rand;
    iter(end+1) = output.iterations;
    count_utility(end+1) = output.funcCount;
    m = [m, x'];
end

results = table;
results.No = [1:number]';
results.utility_ga = utility_ga';
results.norm_g_ga = norm_g_ga';
results.utility_fmincon = utility_fmincon';
results.norm_g_r = norm_g_r';
results.utility_r = utility_r';
results.iter = iter';
results.count = count_utility';

error_of_finite_diff = std(results.utility_fmincon);
utility_ga = mean(utility_ga);
norm_g_ga = mean(norm_g_ga);
utility_fmincon = mean(utility_fmincon);
norm_g_r = mean(norm_g_r);
utility_r = mean(utility_r);
iter = mean(iter);
count = mean(count_utility);

save(['results_','',file_name]);