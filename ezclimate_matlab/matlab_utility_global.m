function re = matlab_utility_global(m_in_mat,varargin)
%m_in_mat = m_in_mat';
row_size = size(m_in_mat);
    for row =1:row_size(1)
        pyr = py.Matlabmod_global.get_u(m_in_mat(row,:),varargin{:});
        re_array = -double(py.array.array('d',py.numpy.nditer(pyr)))';
        re(row) = re_array;
    end
end
