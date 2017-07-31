%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%           Yili Yang, July 2017
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Using the same damage simulation for GA,RBF,QN and GS to use
%--------------------------------------------------------------------------
% Output:
% Table one: the table containing the info after GS
% Table two: the table containing the info after GA-QN
% Table three: the table containing the info after GA-GS
% Table four: the table containing the info after RBF
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
multiprocessing_setup() % set up multiprocessing package, manully call the exectuable of python
varargin = py.Matlabmod.matlabmode(); % init the class in Matlabmode_g
for count = 14:20
profile on
pytuple_GA = py.Matlabmod.get_start(varargin);% call GA in matlabmode_g to get a start point for the local optimizer
m_in_mat_0 = double(py.array.array('d',py.numpy.nditer(pytuple_GA(2))))'; % change the numpy array mitigation level to double in matlab
[utlity_GA,g_GA] = matlab_utility_g_multiprocessing(m_in_mat_0,varargin);% get the utilty and gradient after GA
norm_g_GA = norm(g_GA);% get the norm of gradient after GA
pytuple_gs = py.Matlabmod.call_gs(pytuple_GA(1),varargin);%get the result of GS
m_gs = double(py.array.array('d',py.numpy.nditer(pytuple_gs(1))));
utility_gs = -double(py.array.array('d',py.numpy.nditer(pytuple_gs(2))));
final_norm_g_GS = norm(double(py.array.array('d',py.numpy.nditer(py.Matlabmod.get_g(m_gs,varargin)))));

fun = @matlab_utility_g_multiprocessing;
[fmin2,xmin2,fcount2,gcount,iter] = Quasi_Newton(fun,m_in_mat_0,varargin);% run Quasi_Newton loacl optimizer
[ff,fg] = fun(xmin2,varargin);
final_norm_g_QN = norm(fg);
percentage_decrease = (fmin2-utility_gs)/utility_gs;

%%
%As starting points please use both:
%1) what you get at the end of phase 1, 
%2) what was originally coded. 
%What to report in each table: 
%final norm of gradient (or optimality conditions if the solution happens at the boundary), 
%number of iterations, 
%number of function evaluations, 
%final function value
%percentage decrease.
TABLE1 = table(utlity_GA,norm(g_GA),...
    'VariableNames',{'Utility_after_GA','Norm_of_gradient_after_GA'});
TABLE2 = table(final_norm_g_QN,iter,fcount2,fcount2,fmin2,percentage_decrease,...
    'VariableNames',{'Final_norm_of_gradient','Number_of_iterations','Number_of_utility_evaluations','Number_of_gradient_evaluations','final_function_value','percentage_decrease'});
TABLE3 = table(final_norm_g_GS,200,200,200,utility_gs,0,...
    'VariableNames',{'Final_norm_of_gradient','Number_of_iterations','Number_of_utility_evaluations','Number_of_gradient_evaluations','final_function_value','percentage_decrease'});
profile off
save(['GA_GS_QN_','',num2str(count)])
profsave(profile('info'),['GA_GS_QN_profile_','',num2str(count)])
end

file_name = 'GA_GS_QN_';%read the results
number = 'How manys files need to be read?';
number = input(number);
utility_after_ga = [];
utility_after_gs = [];
norm_after_ga = [];
final_norm_grad_gs = [];
final_norm_grad_qn = [];
num_of_utility = [];
num_of_grad_qn = [];
num_of_iter = [];
final_value = [];
m_qn = [];

for x = 1:number
    load([file_name, '', num2str(x), '', '.mat']);
    utility_after_ga(end+1) = utlity_GA;
    utility_after_gs(end+1) = utility_gs;
    norm_after_ga(end+1) = norm_g_GA;
    final_norm_grad_gs(end+1) = final_norm_g_GS;
    final_norm_grad_qn(end+1) = final_norm_g_QN;
    num_of_utility(end+1) = fcount2;
    num_of_grad_qn(end+1) = fcount2;
    num_of_iter(end+1) = iter;
    final_value(end+1) = fmin2;
    m_qn = [m_qn, xmin2];
end

 m_qn=[m_qn, mean(m_qn,2),std(m_qn,1,2)];
 results = table;
 results.No = [1:number]';
 results.utility_after_ga = utility_after_ga';
 results.utility_after_gs = utility_after_gs';
 results.norm_after_ga = norm_after_ga';
 results.final_norm_grad_gs = final_norm_grad_gs';
 results.final_norm_grad_qn = final_norm_grad_qn';
 results.num_of_iter = num_of_iter';
 results.num_of_utility = num_of_utility';
 results.num_of_grad_qn = num_of_grad_qn';
 results.final_value = final_value';
 
 error_init = std(final_value);
 error_gs= std(utility_after_gs);
 utility_after_ga = mean(utility_after_ga);
 utility_after_gs = mean(utility_after_gs);
 norm_after_ga = mean(norm_after_ga);
 final_norm_grad_gs = mean(final_norm_grad_gs);
 final_norm_grad_qn = mean(final_norm_grad_qn);
 num_of_utility = mean(num_of_utility);
 num_of_grad_qn = mean(num_of_grad_qn);
 num_of_iter = mean(num_of_iter);
 final_value = mean(final_value);
 
 save(['results_','',file_name,'','.mat']);