for count = 10:
profile on
multiprocessing_setup() % set up multiprocessing package, manully call the exectuable of python
varargin = py.Matlabmod.matlabmode(-1); % init the class in Matlabmode_g
pytuple_GA = py.Matlabmod.get_start(varargin);% call GA in matlabmode_g to get a start point for the local optimizer
m_in_mat_0 = double(py.array.array('d',py.numpy.nditer(pytuple_GA(2))))'; % change the numpy array mitigation level to double in matlab
[utlity_GA,g_GA] = matlab_utility_g_multiprocessing(m_in_mat_0,varargin);% get the utilty and gradient after GA
norm_g_GA = norm(g_GA);% get the norm of gradient after GA
f_fun = @(x)matlab_utility_g(x,varargin);
[x,fval,exitflag,output,lambda,grad,hessian]= fmincon(f_fun,m_in_mat_0,eye(63,63),2*ones(1,63));% run Quasi_Newton loacl optimizer
save(['GA_fmincon_','',num2str(count)])
profile off
profsave(profile('info'),['GA_fmincon_profile_','',num2str(count)])
end

file_name = 'GA_Fmincon_'; %read the results
number = 'How manys files need to be read?';
number = input(number);
utility_ga = [];
norm_g_ga = [];
utility_fmincon = [];
gradient = [];
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

save(['results_','',file_name,'',num2str(x)]);