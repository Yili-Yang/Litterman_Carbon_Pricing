function [fmin1,xmin1,iter1,xbar_min1,fbar_min1] = run_RBF(m,y)

varargin = y;
myfun = @matlab_utility_global;
dim = 63;
x = double(zeros(m,63));
for ii =1:m
    x(ii,:) = rand(1,63);
end
gamma=1; % a parameter in RBF (phi function)
deg=-1; % in the RBF model, p(x) is set to zero.
%
% Choose the Phases
%gr_phase2=-1 % Do  Phase 1 only.
% gr_phase2 = 0;% function values only in Phase 2, no smoothing
%gr_phase2 = 1; % use gradinet in Phase 2, no smoothing
%gr_phase2=2 ; % use gradeint and Hessian in phase 2 (trust region)
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

[fmin1,xmin1,iter1,xbar_min1,fbar_min1]=global_RBF_TRM(myfun,x,f,ind,xstar,Ls,method,deg,gamma,useg,varargin);