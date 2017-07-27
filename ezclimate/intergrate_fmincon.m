
for count = 1:1
profile on
multiprocessing_setup() % set up multiprocessing package, manully call the exectuable of python
varargin = py.Matlabmod.matlabmode(); % init the class in Matlabmode_g
m_in_mat_0 = ones(63,1);
[utlity_GA,g_GA] = matlab_utility_g_multiprocessing(m_in_mat_0,varargin);% get the utilty and gradient after GA
norm_g_GA = norm(g_GA);% get the norm of gradient after GA
f_fun = @(x)matlab_utility_g(x,varargin);
[x,fval,exitflag,output,lambda,grad,hessian]= fmincon(f_fun,m_in_mat_0,eye(63,63),2*ones(1,63));% run Quasi_Newton loacl optimizer
save(['fmincon/fmincon_','',num2str(count)])
profile off
profsave(profile('info'),['fmincon/fmincon_profile_','',num2str(count)])
timer = profile('info');
time_structure = timer.FunctionTable.Totaltime;
end