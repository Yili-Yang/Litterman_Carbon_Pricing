y = py.Matlabmod_g.matlabmode();
m_0 = py.Matlabmod_g.get_start(y);
m_in_mat_0 = double(py.array.array('d',py.numpy.nditer(m_0)))';
varargin = y;
fun = @matlab_utility_g;
[fmin2,xmin2,fcount2] = Quasi_Newton(fun,m_in_mat_0,varargin)