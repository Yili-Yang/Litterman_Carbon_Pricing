function[TABLE1,TABLE2,TABLE3] = compare_SA_RBF(problem,probstop)

% Run the global optimizer: compare global_RBF_TRM and SA in phase 1
%gr_pahse2=1
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
%
% output
%
% TABLE1 - - 11 columns table for RBF
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
%  col11 f2_value :  the function value of phase 2 from initial point
% TABLE1 - - 11 columns table for SA

%
gcount = 0;
fcount2=0;
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
ph1time=zeros(probstop -problem+1,1);
%SA
f_ph1s=zeros(probstop -problem+1,1);
it_ph1s=zeros(probstop -problem+1,1);
f_ph2s=zeros(probstop -problem+1,1);
it_ph2s=zeros(probstop -problem+1,1);
gNums=zeros(probstop -problem+1,1);
gNorms=zeros(probstop -problem+1,1);
ph1times=zeros(probstop -problem+1,1);


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
        lb=-100; ub=100;;
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
        myfun=@langer;
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
        myfun=@ackley;
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
        myfun=@drop;
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
    elseif k ==16
        %%%%%%%%%%%
        % PROBLEM 16 (molefd_1f1d)
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
    elseif k ==17
        
        %%%%%%%%%%%
        % PROBLEM 17 (2-D molecule problem ) molefd_1f2d
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
    elseif k ==18
        
        %%%%%%%%%%%
        % PROBLEM 19 (2-D molecule problem with special structure) molefd_1f2d
        %%%%%%%%%%%
        myfun=@molefd_1f2d; % special case
        %
        % set the dimension of the problem, dim. Fuinction rast allows for any dimension to be
        % chosen
        dim = 16;
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
        DM = mole_2d_case (dim);
        varargin=DM; % a parameter
        dim=2*dim;
        %
    elseif k ==19
        
        %%%%%%%%%%%
        % PROBLEM 20 (3-D molecule problem w) molefd_1f3d
        %%%%%%%%%%%
        myfun=@molefd_1f3d;
        %
        % set the dimension of the problem, dim. Fuinction rast allows for any dimension to be
        % chosen
        dim = 10;
        m= 2;
        % determine the inital m points to evaluate the RBF
        lb=-10; ub=10;
        x=(-lb+ub).*(2*rand(m,3*dim)-1)/2+(lb+ub)/2;
         
        % create problem
        perc_nnz=0.1;
        [ DM,xmole,ymole,zmole,xx] = make_mole_3d (perc_nnz,dim);
%         DM = mole_3d_case (dim);
        varargin=DM; % a parameter
        dim=3*dim;
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
    % RBF_TRM
    t1=cputime;
    [fmin1,xmin1,iter1,xbar_min1,fbar_min1]=global_RBF_TRM(myfun,x,f,ind,xstar,Ls,method,deg,gamma,useg,varargin);
    t1=cputime-t1;
    %SA
    options = optimoptions(@fmincon,'GradObj','on','Hessian','on',...
    'Algorithm','trust-region-reflective','Display','off');
    delta=[10*0.5.^(0:8),0];
    L=9; 
    srmin=1;
    lbs=lb*ones(dim,1);
    ubs=ub*ones(dim,1);
    tracking=0;
    kB=1;
    x0=(-lb+ub).*(2*rand(dim,1)-1)/2+(lb+ub)/2;
    T0=abs(feval(myfun,x0,varargin));
    Ts=T0*0.9.^(0:9);
    t1s=cputime;
    [xmin1s,fmin1s,iter1s] = SmoothSA(myfun, x0, xstar, Ts, kB, L, delta, srmin, lbs, ubs, tracking, varargin);
%     [xmin1s2,fmin1s2,~,outp]=fmincon(myfun,xmin1s,[], [], [], [], lbs, ubs,[],options,varargin);
%     iter1s=iter1s+outp.funcCount;
%     xmin1s=xmin1s2;
%     fmin1s=fmin1s2;
     t1s=cputime-t1s;
    % Phase 2:
    
    %RBF_TRM
    [fmin2,xmin2,fcount2,gcount]=quasi_newton(myfun,xmin1,varargin);
    %SA
    [fmin2s,xmin2s,fcount2s,gcounts]=quasi_newton(myfun,xmin1s,varargin);

    % write in table
    %RBF_TRM
    fname(ic)=cellstr(func2str(myfun));
    ProbNo(ic)=k;
    Probdim(ic)=dim;
    f_init(ic)=f(ind);
    f_ph1(ic)= fmin1;
    it_ph1(ic) = iter1;
    f_ph2(ic)= fmin2;
    it_ph2(ic)= fcount2;
    gNum(ic)= gcount; 
    [~,g]=feval(myfun,xmin2,varargin);
    gNorm(ic)= norm(g);
    ph1time(ic)=t1;
    %SA
    fname(ic)=cellstr(func2str(myfun));
    ProbNo(ic)=k;
    Probdim(ic)=dim;
    f_init(ic)=f(ind);
    f_ph1s(ic)= fmin1s;
    it_ph1s(ic) = iter1s;
    f_ph2s(ic)= fmin2s;
    it_ph2s(ic)= fcount2s;
    gNums(ic)= gcounts; 
    [~,g]=feval(myfun,xmin2s,varargin);
    gNorms(ic)= norm(g);
     ph1times(ic)=t1s;
   ic = ic+1;
    
end

TABLE1 = table(ProbNo,fname,Probdim,f_init,f_ph1,it_ph1,f_ph2,...
    it_ph2,gNum,gNorm,ph1time,...
    'VariableNames',{'ProbNo','fname','Probdim','f_init',...
    'f_ph1','it_ph1','f_ph2','it_ph2','gNum','gNorm','ph1time'});
TABLE2 = table(ProbNo,fname,Probdim,f_init,f_ph1s,it_ph1s,f_ph2s,...
    it_ph2s,gNums,gNorms,ph1times,...
    'VariableNames',{'ProbNo','fname','Probdim','f_init',...
    'f_ph1s','it_ph1s','f_ph2s','it_ph2s','gNums','gNorms','ph1times'});
TABLE3 = table(ProbNo,fname,Probdim,f_init,f_ph1,f_ph1s,f_ph2,f_ph2s,...
    it_ph1,it_ph1s,it_ph2,it_ph2s,...
    'VariableNames',{'ProbNo','fname','Probdim','f_init',...
    'f_ph1','f_ph1s','f_ph2','f_ph2s',...
    'it_ph1','it_ph1s','it_ph2','it_ph2s'});

