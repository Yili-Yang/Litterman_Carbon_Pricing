file_name = 'GA_fmincon_';
number = 'How manys files need to be read?';
number = input(number);
utility_ga = [];
norm_g_ga = [];
gradient = [];
utility_fmincon = [];
iter = [];
count_utility = [];
m = [];

for x = 1:number
    load([file_name, '', num2str(x),'','.mat']);
    utility_ga(end+1) = utlity_GA;
    norm_g_ga(end+1) = norm_g_GA;
    utility_fmincon(end+1) = fval;
    gradient(end+1) = norm(grad);
    iter(end+1) = output.iterations;
    count_utility(end+1) = output.funcCount;
    m = [m, x'];
end

results = table;
results.No = [1:number]';
results.utility_ga = utility_ga';
results.norm_g_ga = norm_g_ga';
results.utility_fmincon = utility_fmincon';
results.iter = iter';
results.gradient = gradient';
results.count = count_utility';

error_init = std(results.utility_fmincon);
utility_ga = mean(utility_ga);
norm_g_ga = mean(norm_g_ga);
utility_fmincon = mean(utility_fmincon);
iter = mean(iter);
count = mean(count_utility);
gradient = mean(gradient);

save(['results_','',file_name]);