function re_array = matlab_utility(m_in_mat)
re_array = py.Matlabmod.get_py_m(m_in_mat);
re_array = double(py.array.array('d',py.numpy.nditer(re_array)))
end
