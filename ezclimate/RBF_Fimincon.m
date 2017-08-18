%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%           Yili Yang, Aug 2017
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Use the radial basis function (RBF) as the gloabl minizer and fmincon
% as local minizer.
%
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
% fcount: Number of function evaluations in RBF
% 
% fval - final function value
%
% x - final point where we stop
%
% exitflag - exit flag of the fmincon
%
% output - output cell of the fmincon
%
% grad - final gradient when the fmincon stops
%
% hessian - final hessian when the fmincon stops
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
norm_g_RBF = norm(g_RBF);% get the norm of gradient after GA
f_fun = @(x)matlab_utility_g(x,varargin);
[x,fval,exitflag,output,lambda,grad,hessian]= fmincon(f_fun,xmin1,eye(63,63),ones(1,63));% run Quasi_Newton loacl optimizer