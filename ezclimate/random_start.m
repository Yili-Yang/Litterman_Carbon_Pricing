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
save('random_100')

file_name = 'random_'; %read the results
x = 'How many files need to be read?';
x = input(x);
load([file_name,'',num2str(x),'','.mat']);
utility = mean(u_matrix);
std = std(u_matrix);
save(['results_','', file_name,'', num2str(x)]);