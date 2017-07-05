m_0 = py.Matlabmod.get_init_m();
%m_in_mat_0 = double(py.array.array('d',m_0));
%fun = @(x)matlab_utility(x);
%result_m = fmincon(fun,m_in_mat_0,eye(63),ones(1,63))