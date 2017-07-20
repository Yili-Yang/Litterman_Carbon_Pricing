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
pytuple_GA = py.Matlabmod.get_start(varargin);% call GA in matlabmode_g to get a start point for the local optimizer
m_in_mat_0 = double(py.array.array('d',py.numpy.nditer(pytuple_GA(2))))'; % change the numpy array mitigation level to double in matlab
[utlity_GA,g_GA] = matlab_utility_g_multiprocessing(m_in_mat_0,varargin);% get the utilty and gradient after GA
norm_g_GA = norm(double(py.array.array('d',py.numpy.nditer(g_GA))));% get the norm of gradient after GA
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
m=100;
myfun = @matlab_utility_global;
dim = 63;
%randomly generates the start mitigation level 
x = double(zeros(m,63));
for ii =1:m
    x(ii,:) = rand(1,63);
end
gamma=1; % a parameter in RBF (phi function)
deg=-1; % in the RBF model, p(x) is set to zero.
% evaluate the objective fcn at each of these m points
f=zeros(m,1);
for jj=1:m
    xjj_size = size(x(jj,:));
    f(jj)=-double(py.array.array('d',py.numpy.nditer(myfun(x(jj,:),varargin))));
end
%
% determine the index of the starting point for the optimization
ind=find(f==min(f));

%
% set the mono decreasing lambda sequence
Ls=[10*0.3.^(0:2),0];
%
% set the global minimizer guesstimate
xstar=2*(2*rand(dim,1)-1);
%
% gradient used?
useg=0; % gradient is not used
%
% set the function used in the RBF approximation
method='cubic';

% Phase 1 (does not require derivatives)
%

[fmin1,xmin1,iter1,xbar_min1,fbar_min1,fcount]=global_RBF_TRM(myfun,x,f,ind,xstar,Ls,method,deg,gamma,useg,varargin);
percentage_decrease_RBF = (fmin1 - utility_gs)/utility_gs;
xmin = xmin1';
RBF_norm_g = py.Matlabmod.get_g(xmin,varargin); 
RBF_norm_g = norm(double(py.array.array('d',py.numpy.nditer(RBF_norm_g))));
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
TABLE4 = table(RBF_norm_g,iter1,fcount,fcount,fmin1,percentage_decrease_RBF,...
    'VariableNames',{'Final_norm_of_gradient','Number_of_iterations','Number_of_utility_evaluations','Number_of_gradient_evaluations','final_function_value','percentage_decrease'});
save('GA_GS_QN_RBF')
