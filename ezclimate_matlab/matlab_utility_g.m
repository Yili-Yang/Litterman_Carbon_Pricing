function [re_array,g] = matlab_utility_g(m_in_mat)
pytuple = py.Matlabmod_g.get_utility(m_in_mat);
re_array = double(py.array.array('d',pytuple(1)));
g = double(py.array.array('d',py.numpy.nditer(pytuple(2))))';
end
