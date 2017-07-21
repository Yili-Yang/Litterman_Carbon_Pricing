function re_array = matlab_utility_g(m_in_mat,varargin)
gamma =1e6;
epi = 1e-3;
m_in_mat = m_in_mat';
pytuple = py.Matlabmod.get_u_g(m_in_mat,varargin{:});
re_array = -double(py.array.array('d',pytuple(1)));
end
