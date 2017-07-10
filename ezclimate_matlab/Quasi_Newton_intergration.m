m_0 = py.Matlabmod_g.get_init_m();
m_in_mat_0 = double(py.array.array('d',m_0));
fun = @(x)matlab_utility_g(x);
[fmin2,xmin2,fcount2] = quasi_newton(fun,m_in_mat_0)