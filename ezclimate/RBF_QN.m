%%
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
[fmin2,xmin2,fcount2,gcount,iter] = Quasi_Newton(fun,xmin1,varargin);% run Quasi_Newton loacl optimizer
[ff,fg] = fun(xmin2,varargin);
final_norm_g_QN = norm(fg);
%percentage_decrease_RBF_QN = (fmin2-utility_gs)/utility_gs;
profile off
save(['RBF_QN','',num2str(count)])
profsave(profile('info'),['RBF_QN/RBF_QN_profile_','',num2str(count)])
end