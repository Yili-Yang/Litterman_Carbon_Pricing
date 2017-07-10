m_0 = py.Matlabmod.get_py_m(zeros(1,63));
m_in_mat_0 = double(py.array.array('d',m_0));
%fun = @(x)matlab_utility(x);
%result_m = fmincon(fun,m_in_mat_0,eye(63),ones(1,63))