function TABLE1 = test_mole_phase1(gamma,deg)

%test phase1: global_RBF_TRM 
% compare f_phase1 and f_phase2 to find out 
% whether phase 1 works
% input
%   gamma -- a parameter in phase 1 RBF (phi function)
%     deg -- in the RBF model, p(x) is set to zero.
% usually, gamma=1; deg=-1;



ProbNo=zeros(1);
Probdim=zeros(1);
f_init=zeros(1);
f_ph1=zeros(1);
it_ph1=zeros(1);
f_ph2=zeros(1);
it_ph2=zeros(1);
gNum=zeros(1);
fname=cell(1);
gNorm=zeros(1);
f2_value=zeros(1);

 % PROBLEM 6 (1-D molecule problem with zero soln)
 %%%%%%%%%%%
 myfun=@rast;
 %
 % set the dimension of the problem, dim. Fuinction rast allows for any dimension to be
 % chosen
 dim = 10;
 %
 %
 % m is the number of initial points used for the radial basis function
 % approx.
 m= 2;
 % determine the inital m points to evaluate the RBF
 lb=-10; ub=10;
 x=(-lb+ub).*(2*rand(m,dim)-1)/2+(lb+ub)/2;
 %
 % create problem
%  perc_nnz=.5;
%  [ DM, xmole] = make_mole_1d (perc_nnz,dim);
  varargin=0; % a parameter
 
  %%%%%%%%%END OF PROBLEM SET-UP
    
    f=zeros(m,1);
    for j=1:m
        f(j)=myfun(x(j,:),varargin);
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
    [fmin11,xmin11,iter11,xbar_min11,fbar_min11]=RBFTRM_lsmooth(myfun,x,f,ind,xstar,Ls,method,deg,gamma,useg,varargin);
    %
    %  'initial function value', f(ind)
    %'number of function evaluation',  iter1
    %'function value of global min (phase 1)', fmin1
    % Apply phase 2?
    % Phase 2:
% gr_phase2 ==1 % apply quasi-Newton starting at xmin1
[fmin2,xmin2,fcount2,gcount]=quasi_newton(myfun,xmin1,varargin);
[fmin23,xmin23,fcount23,gcount3]=quasi_newton(myfun,xmin11,varargin);
[fmin22,~,~,~]=quasi_newton(myfun,x(ind,:)',varargin);
%         [fmin2,xmin2,fcount2,gcount]=ADforward_QN(myfun,xmin1,varargin);
ic=1;
fname(ic)=cellstr(func2str(myfun));
ProbNo(ic)=1;
Probdim(ic)=dim;
f_init(ic)=f(ind);
f_ph1(ic)= fmin1;
it_ph1(ic) = iter1;
f_ph2(ic)= fmin2;
it_ph2(ic)= fcount2;
gNum(ic)= gcount;
[~,g]=feval(myfun,xmin2,varargin);
gNorm(ic)= norm(g);
f2_value(ic)= fmin22;

TABLE1 = table(ProbNo,fname,Probdim,f_init,f_ph1,it_ph1,f_ph2,...
    it_ph2,gNum,gNorm,f2_value,...
    'VariableNames',{'ProbNo','fname','Probdim','f_init',...
    'f_ph1','it_ph1','f_ph2','it_ph2','gNum','gNorm','f2_value'});

dm=[1:6];
plot(dm,[f_init,f_ph1,fmin11,f_ph2,fmin23,fmin22],'-*');