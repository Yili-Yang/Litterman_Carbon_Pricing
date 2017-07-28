u_matrix_GA=[];
g_matrix_GA=[];
multiprocessing_setup() % set up multiprocessing package, manully call the exectuable of python
varargin = py.Matlabmod.matlabmode(-1); % init the class in Matlabmode_g
profile on
for count = 1:100
profile on
pytuple_GA = py.Matlabmod.get_start(varargin);% call GA in matlabmode_g to get a start point for the local optimizer
m_in_mat_0 = double(py.array.array('d',py.numpy.nditer(pytuple_GA(2))))'; % change the numpy array mitigation level to double in matlab
[utlity_GA,g_GA] = matlab_utility_g_multiprocessing(m_in_mat_0,varargin);% get the utilty and gradient after GA
u_matrix_GA = [u_matrix_GA;utlity_GA];
g_matrix_GA = [g_matrix_GA;norm(g_GA)];
end
profile off
save('GA_100')
profsave(profile('info'),'GA_100')

file_name = 'GA_'; %read the results
x = 'How many files need to be read?';
x = input(x);
load([file_name,'',num2str(x),'','.mat']);
utility = [u_matrix_GA];
ave_utility = mean(utility);
save(['results_','',file_name,'',num2str(x)]);