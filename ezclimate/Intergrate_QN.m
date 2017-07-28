multiprocessing_setup() % set up multiprocessing package, manully call the exectuable of python
varargin = py.Matlabmod.matlabmode(-1); % init the class in Matlabmode_g
for count =26:28
profile on
m_in_mat_0 = ones(1,63)';
fun = @matlab_utility_g_multiprocessing;
[fmin2,xmin2,fcount2,gcount,iter] = Quasi_Newton(fun,m_in_mat_0,varargin);% run Quasi_Newton loacl optimizer
[ff,fg] = fun(xmin2,varargin);
final_norm_g_QN = norm(fg);
profile off
save(['QN/QN_random_','',num2str(count)])
profsave(profile('info'),['QN/QN_random_profile_','',num2str(count)])

end