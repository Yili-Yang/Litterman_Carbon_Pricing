%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%           Yili Yang, Aug 2017
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Use the radial basis function (RBF) as the gloabl minizer and
% Quasi-Newton as the local minizer
% Inputs:
% myfun - original function. Can be a handle to the function to be minimized.
%
% xbar - the points we use to build the RBF model. xbar is mxn where
% m is the number of points used for the model, and n is the dimension.
%
% fbar - function value at xbar(~,:)
%
% ind - index of the starting point in xbar. that is xbar(ind,:) is
% the starting point for the optimzation procedure.
%
% method - type of phi function for RBF model. method is a string variable.
% current choices are 'cubic', 'multiquadric1', 'multiquadric2', 'inmultiquadric',
% 'Gaussian'. See function 'phifunc' for more detail
%
% deg - degree of p(x) in RBF model.
% if deg = -1, p(x) = 0, if deg = 0 a constant, p(x) = a,  is used
% if deg = 1 a linear fcn , p(x) = b'x+a, is used. .
% See function RBFM for more details.
%
%
% gamma - parameter for phi function. default gamma = 1;
%
% varargin - additional parameters for myfun
%
% useg - useg = 1 indicates the gradient will be computed at eaxh point
%        and used in the trust region problem
% xstar - initial guessestimate of the global optiimum
%
% ls - lambda sequence for smoothing part, last entry should be 0.
% A default sequnce is suppplied below
%
% varargin - instance of matlabmode class which contains the default
% classed such as  tree, damage, cost and etc. to calculate the utility
%
% Output:
% fmin1 - final function value at computed optimum by RBF
%
% xmin1 - the computed optimum by RBF
%
% iter1 - number of iterations within RBF
%
% xbar_min1 - an array of the points (n-vectors) at which the objective function
% was evaluated by RBF
%
% fbar_min1 - the vector ofobjective function values at all points in xxbar
% by RBF
%
% fcount - Number of function evaluations in RBF
%
% fmin2 - final function value at computed optimum by Qn
%
% xmin2 - the computed optimum by QN
%
% fcount2 - Number of function evaluations in QN
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
multiprocessing_setup() % set up multiprocessing package, manully call the exectuable of python
m=100;
for count = 9:10
profile on
%load(['GA_GS_QN_','',num2str(count)])
varargin = py.Matlabmod.matlabmode(); % init the class in Matlabmode
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
%percentage_decrease_RBF = (fmin1 - utility_gs)/utility_gs;
[utlity_RBF,g_RBF] = matlab_utility_g_multiprocessing(xmin1,varargin);% get the utilty and gradient after GA
norm_g_RBF = norm(g_RBF);% get the norm of gradient after GA

fun = @matlab_utility_g_multiprocessing;
[fmin2,xmin2,fcount2,~,iter] = Quasi_Newton(fun,xmin1,varargin);% run Quasi_Newton loacl optimizer
[ff,fg] = fun(xmin2,varargin);
final_norm_g_QN = norm(fg);
%percentage_decrease_RBF_QN = (fmin2-utility_gs)/utility_gs;
profile off
save(['RBF_QN_','',num2str(count)])
profsave(profile('info'),['RBF_QN/RBF_QN_profile_','',num2str(count)])
end

file_name = 'RBF_QN_'; %read the results
number = 'How manys files need to be read?';
number = input(number);
utility_after_rbf = [];
utility_after_qn = [];
final_norm_grad_gs = [];
final_norm_grad_qn = [];
norm_grad_rbf = [];
num_iter_qn = [];
num_iter_rbf = [];
num_of_utility = [];
num_of_grad_qn = [];
final_value = [];

for x = 1:number
    load([file_name, '', num2str(x), '', '.mat']);
    utility_after_rbf(end+1) = utlity_RBF;
    utility_after_qn(end+1) = fmin2;
    final_norm_grad_gs(end+1) = final_norm_g_GS;
    final_norm_grad_qn(end+1) = final_norm_g_QN;
    norm_grad_rbf(end+1) = norm_g_RBF;
    num_iter_qn(end+1) = iter;
    num_iter_rbf(end+1) = iter1;
    num_of_utility(end+1) = fcount2;
    num_of_grad_qn(end+1) = fcount2;
    final_value(end+1) = fmin2;
end
 results = table;
 results.No = [1:number]';
 results.utility_after_rbf = utility_after_rbf';
 results.utility_after_qn = utility_after_qn';
 results.norm_graf_rbf = norm_grad_rbf';
 results.final_norm_grad_gs = final_norm_grad_gs';
 results.final_norm_grad_qn = final_norm_grad_qn';
 results.num_iter_qn = num_iter_qn';
 results.num_iter_rbf = num_iter_rbf';
 results.num_of_utility = num_of_utility';
 results.num_of_grad_qn = num_of_grad_qn';
 results.final_value = final_value';
 
 error_init = std(final_value);
 utility_after_rbf = mean(utility_after_rbf);
 utility_after_qn = mean(utility_after_qn);
 norm_grad_rbf = mean(norm_grad_rbf);
 final_norm_grad_gs = mean(final_norm_grad_gs);
 final_norm_grad_qn = mean(final_norm_grad_qn);
 num_iter_qn = mean(num_iter_qn);
 num_iter_rbf = mean(num_iter_rbf);
 num_of_utility = mean(num_of_utility);
 num_of_grad_qn = mean(num_of_grad_qn);
 final_value = mean(final_value);
  
 save(['results_','',file_name,'', num2str(x)]);