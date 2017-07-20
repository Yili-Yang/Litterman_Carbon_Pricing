function re = matlab_utility_g(m_in_mat,varargin)
gamma =1e6;
epi = 1e-3;
m_in_mat = m_in_mat';
pytuple = py.Matlabmod.get_u_g(m_in_mat,varargin{:});
re_array = -double(py.array.array('d',pytuple(1)));
positive_add_up = 0;
m_size = size(m_in_mat);
for col = 1:m_size(2)
    positive_add_up = positive_add_up + gamma*(min(m_in_mat(1,col)-epi,0))^2;
end
if isnan(re_array) >0
    re = positive_add_up;
else
    re = re_array + positive_add_up;
end
disp(re)