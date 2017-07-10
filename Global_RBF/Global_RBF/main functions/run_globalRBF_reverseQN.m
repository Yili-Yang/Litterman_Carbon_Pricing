function [TABLE3] = run_globalRBF_reverseQN(problem,probstop,gr_phase2,useg);
%[TABLE1,TABLE2,TABLE3,TABLE4] = run_global_RBF_TRM(problem,probstop,gr_phase2,useg);
% Run the global optimizer: global_RBF_TRM
% use MATLAB function "fminunc" at phase 2, algorithm is quasi_newton.
% global_RBF_TRM has 2 phases. It is possible to apply phase 1 opnly
%
% INPUT
%
% problem: the problem #to start at
% probstop: the problem # to stop at
%
% gr_phase2: gr_phase2 < 0 - do phase 1 only.
%            Phase 1 only requires function values (can use gradients if
%            useg=1)
%            gr_phase2 ==0 - phase 2 contines Phase 1 with nio smoothing
%            gr_phase2 == 1 = Phase 2 uses a QN method with gradient comp.
%            gr_phase2 ==2  - Phase 2 uses gradeints and hessians (TRM)
% useg ==0,  then no gradient info is used in Phase 1
% useg == 1  then gradient info is used in Phase 1.
%
% output
%
% TABLE - - 10 columns table
%  col1   ProbNo :  the No. of Problem
%  col2   fname  :  function name
%  col3   Probdim?  dimension of Problem
%  col4   f_init :  initial value of objective function
%  col5   f_ph1  :  objective function value of phase 1
%  col6   it_ph1 :  iteration numbers of phase 1
%  col7   f_ph2  :  objective function value of phase 2
%  col8   it_ph2 :  iteration numbers of phase 2
%  col9   gNum   :  gradient numbers of phase 2
%  col10  gNorm  :  gradient norm value of phase 2
%
% xmatrix  - - solution x at each phase
%              row size = 50 (> the max dimension)
%              column size = 2*(probstop -problem+1)
%                  For every problem, there are 2 columns
%                  1st column is solution of phase 1
%                  2nd column is solution of phase 2
%TABLE1 - - original method
%TABLE2 - - AD forward
%TABLE3 - - AD reverse
%TABLE4 - - MATLAB method fminunc


%
gcount = 0;
fcount2=0;
if nargin <4, useg = 0; end;
if nargin < 3, gr_phase2 =0; end
if nargin < 2, probstop = problem; end
if nargin <1, problem = 1; end

ProbNo=zeros(probstop -problem+1,1);
Probdim=zeros(probstop -problem+1,1);
f_init=zeros(probstop -problem+1,1);
f_ph1=zeros(probstop -problem+1,1);
it_ph1=zeros(probstop -problem+1,1);
f_ph2=zeros(probstop -problem+1,1);
it_ph2=zeros(probstop -problem+1,1);
gNum=zeros(probstop -problem+1,1);
fname=cell(probstop -problem+1,1);
gNorm=zeros(probstop -problem+1,1);
xmatrix=zeros(50,2*(probstop -problem+1));
f2_value=zeros(probstop -problem+1,1);

% 
f_ph23=zeros(probstop -problem+1,1);
it_ph23=zeros(probstop -problem+1,1);
gNum3=zeros(probstop -problem+1,1);
gNorm3=zeros(probstop -problem+1,1);
f2_value3=zeros(probstop -problem+1,1);



% Solve the problems

ic = 1;
for k=problem:probstop
    % SET THE PROBLEM %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % choose the function to be minimized
    %%%%%%
    %PROBLEM1
    %%%%%%
    if k ==1
        %%%%%%%%%%%
        % PROBLEM 1
        %%%%%%%%%%%
        myfun=@rast ;
        %
        % set the dimension of the problem, dim. Fuinction rast allows for any dimension to be
        % chosen
        dim = 30;
        %
        %
        % m is the number of initial points used for the radial basis function
        % approx.
        m= 2;
        % determine the inital m points to evaluate the RBF
        lb=-100; ub=100;
        x=(-lb+ub).*(2*rand(m,dim)-1)/2+(lb+ub)/2;
        
        varargin=1/40000; % a parameter in rast
    elseif k == 2
        %%%%%%%%%%%
        % PROBLEM 2
        %%%%%%%%%%%
        myfun=@rast ;
        %
        % set the dimension of the problem, dim. Fuinction rast allows for any dimension to be
        % chosen
        dim = 20;
        %
        %
        % m is the number of initial points used for the radial basis function
        % approx.
        m= 2;
        % determine the inital m points to evaluate the RBF
        lb=-100; ub=100;
        x=(-lb+ub).*(2*rand(m,dim)-1)/2+(lb+ub)/2;
        
        varargin=1/40000; % a parameter in rast
        %
    elseif k ==3
        %%%%%%%%%%%
        % PROBLEM 3
        %%%%%%%%%%%
        myfun=@griewank;
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
        
        varargin=0; % a parameter
        %
    elseif k ==4
        %%%%%%%%%%%
        % PROBLEM 4
        %%%%%%%%%%%
        myfun=@griewank2;
        %
        % set the dimension of the problem, dim. Fuinction rast allows for any dimension to be
        % chosen
        dim = 2;
        %
        %
        % m is the number of initial points used for the radial basis function
        % approx.
        m= 2;
        % determine the inital m points to evaluate the RBF
        lb=-10; ub=10;
        x=(-lb+ub).*(2*rand(m,dim)-1)/2+(lb+ub)/2;
        
        varargin=0; % a parameter
        %
        %
    elseif k ==5
        %%%%%%%%%%%
        % PROBLEM 5
        %%%%%%%%%%%
        myfun=@molefd;
        %
        % set the dimension of the problem, dim. Fuinction rast allows for any dimension to be
        % chosen
        dim = 30;
        %
        %
        % m is the number of initial points used for the radial basis function
        % approx.
        m= 2;
        % determine the inital m points to evaluate the RBF
        lb=-10; ub=10;
        x=(-lb+ub).*(2*rand(m,dim)-1)/2+(lb+ub)/2;
        DM = sprandsym(dim,.1);
        [I,J,dist] = find(DM);
        dist = abs(dist);
        DM = sparse(I,J,dist);
        
        varargin=DM; % a parameter
    elseif k ==6
        %%%%%%%%%%%
        % PROBLEM 6 (1-D molecule problem with zero soln)
        %%%%%%%%%%%
        myfun=@molefd;
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
        perc_nnz=.5;
        [ DM, xmole] = make_mole_1d (perc_nnz,dim);
        varargin=DM; % a parameter
    elseif k ==7
        %%%%%%%%%%%
        % PROBLEM 7 (levy13)
        %%%%%%%%%%%
        myfun=@levy13;
        %
        % set the dimension of the problem, dim. Fuinction rast allows for any dimension to be
        % chosen
        dim = 2;
        %
        %
        % m is the number of initial points used for the radial basis function
        % approx.
        m= 2;
        % determine the inital m points to evaluate the RBF
        lb=-10; ub=10;
        x=(-lb+ub).*(2*rand(m,dim)-1)/2+(lb+ub)/2;
        
        varargin=0; % a parameter
        %
    elseif k ==8
        %%%%%%%%%%%
        % PROBLEM 8 (michal)
        %%%%%%%%%%%
        myfun=@michal;
        %
        % set the dimension of the problem, dim. Fuinction rast allows for any dimension to be
        % chosen
        dim = 20;
        %
        %
        % m is the number of initial points used for the radial basis function
        % approx.
        m= 2;
        % determine the inital m points to evaluate the RBF
        lb=-10; ub=10;
        x=(-lb+ub).*(2*rand(m,dim)-1)/2+(lb+ub)/2;
        
        varargin=0; % a parameter
        %
    elseif k ==9
        %%%%%%%%%%%
        % PROBLEM 9 (shubert)
        %%%%%%%%%%%
        myfun=@shubert;
        %
        % set the dimension of the problem, dim. Fuinction rast allows for any dimension to be
        % chosen
        dim = 2;
        %
        %
        % m is the number of initial points used for the radial basis function
        % approx.
        m= 2;
        % determine the inital m points to evaluate the RBF
        lb=-10; ub=10;
        x=(-lb+ub).*(2*rand(m,dim)-1)/2+(lb+ub)/2;
        
        varargin=0; % a parameter
        %
    elseif k ==10
        %%%%%%%%%%%
        % PROBLEM 10 (langer)
        %%%%%%%%%%%
        myfun=@langer_re;
        %
        % set the dimension of the problem, dim. Fuinction rast allows for any dimension to be
        % chosen
        dim = 2;
        %
        %
        % m is the number of initial points used for the radial basis function
        % approx.
        m= 2;
        % determine the inital m points to evaluate the RBF
        lb=-10; ub=10;
        x=(-lb+ub).*(2*rand(m,dim)-1)/2+(lb+ub)/2;
        
        varargin=0; % a parameter
        %
    elseif k ==11
        %%%%%%%%%%%
        % PROBLEM 11 (example3)
        %%%%%%%%%%%
        myfun=@example3;
        %
        % set the dimension of the problem, dim. Fuinction rast allows for any dimension to be
        % chosen
        dim = 2;
        %
        %
        % m is the number of initial points used for the radial basis function
        % approx.
        m= 2;
        % determine the inital m points to evaluate the RBF
        lb=-10; ub=10;
        x=(-lb+ub).*(2*rand(m,dim)-1)/2+(lb+ub)/2;
        
        varargin=0; % a parameter
        %
    elseif k ==12
        %%%%%%%%%%%
        % PROBLEM 12 (example4)
        %%%%%%%%%%%
        myfun=@example4;
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
        
        varargin=0; % a parameter
        %
    elseif k ==13
        %%%%%%%%%%%
        % PROBLEM 13 (ackley)
        %%%%%%%%%%%
        myfun=@ackley_re;
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
        
        varargin=0; % a parameter
        %
    elseif k ==14
        %%%%%%%%%%%
        % PROBLEM 14 (booth)
        %%%%%%%%%%%
        myfun=@booth;
        %
        % set the dimension of the problem, dim. Fuinction rast allows for any dimension to be
        % chosen
        dim = 2;
        %
        %
        % m is the number of initial points used for the radial basis function
        % approx.
        m= 2;
        % determine the inital m points to evaluate the RBF
        lb=-10; ub=10;
        x=(-lb+ub).*(2*rand(m,dim)-1)/2+(lb+ub)/2;
        
        varargin=0; % a parameter
        %
    elseif k ==15
        %%%%%%%%%%%
        % PROBLEM 15 (drop)
        %%%%%%%%%%%
        myfun=@drop_re;
        %
        % set the dimension of the problem, dim. Fuinction rast allows for any dimension to be
        % chosen
        dim = 2;
        %
        %
        % m is the number of initial points used for the radial basis function
        % approx.
        m= 2;
        % determine the inital m points to evaluate the RBF
        lb=-10; ub=10;
        x=(-lb+ub).*(2*rand(m,dim)-1)/2+(lb+ub)/2;
        
        varargin=0; % a parameter
        %
    elseif k ==16
        
        %%%%%%%%%%%
        % PROBLEM 16 (2-D molecule problem with zero soln)
        %%%%%%%%%%%
        myfun=@molefd2;
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
        x=(-lb+ub).*(2*rand(m,2*dim)-1)/2+(lb+ub)/2;
        %
        % create problem
        perc_nnz=0.75;
        [ DM, xmole,ymole,xstar] = make_mole_2d (perc_nnz,dim);
        varargin=DM; % a parameter
        dim = 2*dim;
        %
    elseif k ==17
        %%%%%%%%%%%
        % PROBLEM 17 (molefd_1f1d)
        %%%%%%%%%%%
        myfun=@molefd_1f1d;
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
        perc_nnz=.5;
        [ DM, xmole] = make_mole_1d (perc_nnz,dim);
        varargin=DM; % a parameter
        %
    elseif k ==18
        
        %%%%%%%%%%%
        % PROBLEM 18 (2-D molecule problem with zero soln) molefd_1f2d
        %%%%%%%%%%%
        myfun=@molefd_1f2d;
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
        x=(-lb+ub).*(2*rand(m,2*dim)-1)/2+(lb+ub)/2;
        %
        % create problem
        perc_nnz=0.75;
        [ DM, xmole,ymole,xstar] = make_mole_2d (perc_nnz,dim);
        varargin=DM; % a parameter
        dim = 2*dim;
        %
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%END OF PROBLEM SET-UP
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
    %
    %  'initial function value', f(ind)
    %'number of function evaluation',  iter1
    %'function value of global min (phase 1)', fmin1
    % Apply phase 2?
    % Phase 2:
    fmin2 = fmin1;
    if gr_phase2 ==1 % apply quasi-Newton starting at xmin1
        
      [fmin23,xmin23,fcount23,gcount3]=ADreverse_QN(myfun,xmin1,varargin); 
  [fmin213,~,~,~]=ADreverse_QN(myfun,x(ind,:)',varargin);
%         [~,fmin214,~,~] = fminunc(myfun,x(ind,:)',varargin);
        % 'number of function evaluation in Phase 2',  fcount2
        %'number of gradient evals in Phase 2', gcount
        %'function value of global min (phase 2)', fmin2
    elseif gr_phase2==0
        
        ind2=find(fbar_min1==min(fbar_min1));
        [fmin23,xmin23,fcount23]=RBFTRM(myfun,xbar_min1,fbar_min1,ind2,method,deg,gamma,useg,varargin );
        %'number of function evaluation in Phase 2',  fcount2
        %'function value of global min (phase 2)', fmin2
    end
    
    fname(ic)=cellstr(func2str(myfun));
    ProbNo(ic)=k;
    Probdim(ic)=dim;
    f_init(ic)=f(ind);
    f_ph1(ic)= fmin1;
    it_ph1(ic) = iter1;
    xmatrix(1:length(xmin1),2*ic-1)=xmin1;  
    xmatrix(1:length(xmin1),2*ic)=xmin23;
   
%    

f_ph23(ic)= fmin23;
it_ph23(ic)= fcount23;

n=length(xmin23);
options = setgradopt('revprod', n);
myfun1 = ADfun(func2str(myfun), 1);

if gr_phase2==1
    [~, g] = feval(myfun1, xmin23,varargin,options);
    gNorm3(ic)= norm(g);
    gNum3(ic)= gcount3;
elseif gr_phase2==0
    gNorm3(ic)=NaN;
end
f2_value3(ic)= fmin213;

    ic = ic+1;
%     if problem == 6;
%         OUT = [xmin1, xmin2, xmole]
%     end
    
end


TABLE3 = table(ProbNo,fname,Probdim,f_init,f_ph1,it_ph1,f_ph23,...
    it_ph23,gNum3,gNorm3,f2_value3,...
    'VariableNames',{'ProbNo','fname','Probdim','f_init',...
    'f_ph1','it_ph1','f_ph2','it_ph2','gNum','gNorm','f2_value'});