for count =3:10
profile on
multiprocessing_setup() % set up multiprocessing package, manully call the exectuable of python
varargin = py.Matlabmod.matlabmode(); % init the class in Matlabmode_g
m_in_mat_0 = rand(1,63)';
fun = @matlab_utility_g_multiprocessing;
[fmin2,xmin2,fcount2,gcount,iter] = Quasi_Newton(fun,m_in_mat_0,varargin);% run Quasi_Newton loacl optimizer
[ff,fg] = fun(xmin2,varargin);
final_norm_g_QN = norm(fg);
profile off
save(['QN_','',num2str(count)])
profsave(profile('info'),['QN_profile_','',num2str(count)])
count = count + 1;
end