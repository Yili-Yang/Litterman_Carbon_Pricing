multiprocessing_setup() % set up multiprocessing package, manully call the exectuable of python
varargin = py.MatlabMode_sensitivity.matlabmode(1); % init the class in Matlabmode_g
m_in_mat_0 = rand(1,63)';
fun = @matlab_utility_g_multiprocessing;
[fmin2,xmin2,fcount2,~,iter] = Quasi_Newton(fun,m_in_mat_0,varargin);% run Quasi_Newton loacl optimizer
[~,fg] = fun(xmin2,varargin);
final_norm_g_QN = norm(fg);
price = -double(py.array.array('d',py.numpy.nditer(py.MatlabMode_sensitivity.get_price(xmin2',varargin))))';
parameters = -double(py.array.array('d',py.numpy.nditer(py.MatlabMode_sensitivity.get_parameters(varargin))))';