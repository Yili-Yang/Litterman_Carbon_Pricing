m=100;
y = py.Matlabmod.matlabmode();
varargin = y;
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
percentage_decrease_phase1 = -(fmin1-9.4915710578994563)/9.4915710578994563;
xmin = xmin1';
RBF_norm_g = py.Matlabmod.get_g(xmin,varargin); 
fun_with_grad = @matlab_utility_g_multiprocessing;
[fmin2,xmin2,fcount2,gcount]=quasi_newton(fun_with_grad,xmin1,varargin);
percentage_decrease_phase2 = -(-fmin2-9.4915710578994563)/9.4915710578994563;
[ff,fg] = fun_with_grad(xmin2,varargin);
final_norm_g = norm(fg);