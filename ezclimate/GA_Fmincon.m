multiprocessing_setup() % set up multiprocessing package, manully call the exectuable of python
varargin = py.Matlabmod.matlabmode(); % init the class in Matlabmode_g
pytuple_GA = py.Matlabmod.get_start(varargin);% call GA in matlabmode_g to get a start point for the local optimizer
m_in_mat_0 = double(py.array.array('d',py.numpy.nditer(pytuple_GA(2))))'; % change the numpy array mitigation level to double in matlab
[utlity_GA,g_GA] = matlab_utility_g_multiprocessing(m_in_mat_0,varargin);% get the utilty and gradient after GA
norm_g_GA = norm(g_GA);% get the norm of gradient after GA
f_fun = @(x)matlab_utility_g(x,varargin);
[x,fval,exitflag,output,lambda,grad,hessian]= fmincon(f_fun,m_in_mat_0,eye(63,63),ones(1,63));% run Quasi_Newton loacl optimizer
save('GA_fmincon')