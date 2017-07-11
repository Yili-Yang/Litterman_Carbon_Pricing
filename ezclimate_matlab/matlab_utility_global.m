function re_array = matlab_utility_global(m_in_mat,varargin)
%m_in_mat = m_in_mat';
pyr = py.Matlabmod_global.get_u(m_in_mat,varargin{:});
re_array = double(py.array.array('d',py.numpy.nditer(pyr)))';
end
