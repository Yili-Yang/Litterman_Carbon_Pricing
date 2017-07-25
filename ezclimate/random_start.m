multiprocessing_setup() % set up multiprocessing package, manully call the exectuable of python
varargin = py.Matlabmod.matlabmode(); 
u_matrix = [];
g_matrix =[];
for count =1:100
m_in_mat_0 = rand(1,63)';
[utility_rand,g_rand] = matlab_utility_g_multiprocessing(m_in_mat_0,varargin);% get the utilty and gradient after GA
norm_g_rand = norm(g_rand);% get the norm of gradient after GA
u_matrix = [u_matrix;utility_rand];
g_matrix = [g_matrix;g_rand];
end