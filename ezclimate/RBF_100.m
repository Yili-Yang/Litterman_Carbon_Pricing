u_matrix_RBF = [];
g_matrix_RBF = [];
profile on 
for count = 1:100
multiprocessing_setup() % set up multiprocessing package, manully call the exectuable of python
varargin = py.Matlabmod.matlabmode(); % init the class in Matlabmode_g
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
%percentage_decrease_RBF = (fmin1 - utility_gs)/utility_gs;
[utlity_RBF,g_RBF] = matlab_utility_g_multiprocessing(xmin1,varargin);% get the utilty and gradient after GA
u_matrix_RBF =[u_matrix_RBF;utlity_RBF];
g_matrix_RBF = [g_matrix_RBF;g_RBF];

end
save('RBF_100')
profile off
profsave(profile('info'),'RBF_100')