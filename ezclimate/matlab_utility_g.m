function [re_array,g] = matlab_utility_g(m_in_mat,varargin)
gamma =1e6;
epi = 1e-3;
m_in_mat = m_in_mat';
pytu = py.Matlabmod.get_u(m_in_mat,varargin{:});
re_array = -double(py.array.array('d',py.numpy.nditer(pytu(1))));
g = -double(py.array.array('d',py.numpy.nditer(pytu(2))));
end
