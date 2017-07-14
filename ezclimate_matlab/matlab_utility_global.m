function re = matlab_utility_global(m_in_mat,varargin)
gamma =1e6;
epi = 1e-4;
%m_in_mat = m_in_mat';
ma_size = size(m_in_mat);
    for row =1:ma_size(1)
        positive_add_up = 0;
        for col=1:ma_size(2)
            positive_add_up = positive_add_up + gamma*min(m_in_mat(row,col)-epi,0)^2;
        end
        pyr = py.Matlabmod_global.get_u(m_in_mat(row,:),varargin{:});
        re_array = -double(py.array.array('d',py.numpy.nditer(pyr)))';
        %disp('positive_add_up')
        %disp(positive_add_up)
        if isnan(re_array)>0
            re(row) = positive_add_up;
        else
            re(row) = re_array + positive_add_up;
        end
    end
end
