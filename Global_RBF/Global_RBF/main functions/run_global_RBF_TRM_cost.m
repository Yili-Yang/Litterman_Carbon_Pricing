function[TABLE1,xmatrix,xst] = run_global_RBF_TRM(problem,probstop,gr_phase2,useg)

% Run the global optimizer: global_RBF_TRM
%
% global_RBF_TRM has 2 phases. It is possible to apply phase 1 opnly

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
% TABLE - - 11 columns table
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
%  col11 f_onlyPh2 :  the function value of phase 2 from initial point
% xmatrix  - - solution x at each phase
%              row size = 50 (> the max dimension)
%              column size = 2*(probstop -problem+1)
%                  For every problem, there are 2 columns
%                  1st column is solution of phase 1
%                  2nd column is solution of phase 2
% xst  --- start vector


%%
dirM = 20;
[dirx,diruT,dirA,dirb0] = prepareTestCase(dirM);
dirx=randn(2,4*dirM);

%%

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
f2_value=zeros(probstop -problem+1,1);
xmatrix=zeros(50,2*(probstop -problem+1));


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
        myfun=@cost_of_rast ;
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
        myfun=@cost_of_rast ;
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
        myfun=@cost_of_griewank;
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
        myfun=@cost_of_griewank2;
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
        myfun=@cost_of_molefd;
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
        myfun=@cost_of_molefd;
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
        myfun=@cost_of_levy13;
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
        myfun=@cost_of_michal;
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
        myfun=@cost_of_shubert;
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
        myfun=@cost_of_langer;
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
        myfun=@cost_of_example3;
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
        myfun=@cost_of_example4;
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
        myfun=@cost_of_ackley;
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
        myfun=@cost_of_booth;
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
        myfun=@cost_of_drop;
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
        myfun=@cost_of_molefd_1f1d;
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
        myfun=@cost_of_molefd_1f2d;
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
        myfun=@cost_of_molefd_1f2d; % special case
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
        myfun=@cost_of_molefd_1f3d;
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
        
    elseif k ==20
        
        %%%%%%%%%%%
        % PROBLEM 21 (p-D molecule problem) mole_pd
        %%%%%%%%%%%
        myfun=@cost_of_mole_pd;
        %
        % set the dimension of the problem, dim. Fuinction rast allows for any dimension to be
        % chosen
        %
        p=10;
        dim=10;
        % m is the number of initial points used for the radial basis function
        % approx.
        m= 2;
        % determine the inital m points to evaluate the RBF
        lb=-10; ub=10;
        x=(-lb+ub).*(2*rand(m,p*dim)-1)/2+(lb+ub)/2;
        perc_nnz=0.1;
        [DMp, xmole] = make_mole_pd (p,perc_nnz,dim);
        varargin=DMp; % a parameter
        dim=p*dim;
        %     elseif k ==21
        %         %solving inverse Dirichlet problem
        %         myfun=@Dirichletfun;
        %
        %         M = 20;
        %         xs = [(M:-1:1)/M, (M:-1:1)/M, zeros(1,2*M)]';
        %         %         xs=randn(4*M,1);
        %         idr = [1:M, 1:M:(M^2), M:M:(M^2), (M^2-M+1):(M^2)]';
        %         b0 = sparse(idr,ones(4*M,1),xs);
        %         d1 = -ones(M^2,1); d2 = d1; d2(M:M:end) = 0;
        %         d3 = 4*ones(M^2,1); d4 = [-1;d2(1:(end-1))];
        %         A = spdiags([d1, d2, d3, d4, d1],[-M,-1,0,1,M],M^2,M^2);
        %         B=inv(A);
        %         uT=B*b0;
        %         clear DM;
        %         DM.B=B;
        %         DM.uT=uT;
        %         DM.M = M;
        %         varargin=DM;
        %         m=2;
        %         x=randn(2,4*M);
        %         %         x=zeros(m,4*M);
        %         %         xa = xs + (rand(4*M,1)-0.5)*max(xs);
        %         %         x(1,:)=xa';
        %         %         xc = xs + (rand(4*M,1)-0.5)*max(xs);
        %         %         x(2,:)=xc';
        %         dim=4*M;
    elseif k ==21
        %solving inverse Dirichlet problem
        myfun=@cost_of_Dirichletfun;
        
        M = 20;
        %         % prepare x
        %         xs = [(M:-1:1)/M, (M:-1:1)/M, zeros(1,2*M)]';
        %         % prepare idr
        %         idr = [1:M, 1:M:(M^2), M:M:(M^2), (M^2-M+1):(M^2)]';
        %         % prepare A -- laplaceMatrix
        %         b0 = sparse(idr,ones(4*M,1),xs);
        %         d1 = -ones(M^2,1); d2 = d1; d2(M:M:end) = 0;
        %         d3 = 4*ones(M^2,1); d4 = [-1;d2(1:(end-1))];
        %         A = spdiags([d1, d2, d3, d4, d1],[-M,-1,0,1,M],M^2,M^2);
        %         % prepare B, uT
        %         B=inv(A);
        %         uT=B*b0;
        
        %         [x,uT,A,b0] = prepareTestCase(M);
        uT = diruT;
        A = dirA;
        B = inv(A);
        
        clear DM;
        DM.B=B;
        DM.uT=uT;
        DM.M = M;
        varargin=DM;
        % m is the number of initial points used for the radial basis function
        % approx.
        m=2;
        % determine the inital m points to evaluate the RBF
        %         x=randn(2,4*M);
        x = dirx;
        dim=4*M;
    elseif k ==22
        %solving inverse Dirichlet problem
        myfun=@cost_of_DirichletfunAD;
        
        M = 20;
        %         % prepare x
        %         xs = [(M:-1:1)/M, (M:-1:1)/M, zeros(1,2*M)]';
        %         % prepare idr
        %         idr = [1:M, 1:M:(M^2), M:M:(M^2), (M^2-M+1):(M^2)]';
        %         % prepare A -- laplaceMatrix
        %         b0 = sparse(idr,ones(4*M,1),xs);
        %         d1 = -ones(M^2,1); d2 = d1; d2(M:M:end) = 0;
        %         d3 = 4*ones(M^2,1); d4 = [-1;d2(1:(end-1))];
        %         A = spdiags([d1, d2, d3, d4, d1],[-M,-1,0,1,M],M^2,M^2);
        %         % prepare B, uT
        %         B=inv(A);
        %         uT=B*b0;
        
        %         [x,uT,A,b0] = prepareTestCase(M);
        uT = diruT;
        A = dirA;
        B = inv(A);
        
        clear DM;
        DM.B=B;
        DM.uT=uT;
        DM.M = M;
        varargin=DM;
        % m is the number of initial points used for the radial basis function
        % approx.
        m=2;
        % determine the inital m points to evaluate the RBF
        %         x=randn(2,4*M);
        x = dirx;
        dim=4*M;
    elseif k == 23
        myfun = @cost_of_heatfunAD;
        rng('default'); rng(13);
        dt = 0.1; dx = 0.05; delta = dt/dx^2;
        T = 1; N = T/dt;
        L = 1; M = L/dx;
        [c, u0, uT] = prepareTestCaseHeat(M,N);
        
        clear DM;
        DM.M = M;
        DM.N = N;
        DM.u0 = u0;
        DM.uT = uT;
        
        varargin = DM;
        m = 2;
        %         x = randn(2,3*M);
        c1 = c+(rand(numel(c),1)-.5)*max(c)*.8;
        c2 = c+(rand(numel(c),1)-.5)*max(c)*.8;
        cx = [c1,c2]';
        x = cx;
        dim = 3*M;
        
    elseif k == 24
        myfun = @cost_of_heatfunAD;
        rng('default'); rng(13);
        dt = 0.1; dx = 0.05; delta = dt/dx^2;
        T = 1; N = T/dt;
        L = 1; M = L/dx;
        [c, u0, uT] = prepareTestCaseHeat(M,N);
        
        clear DM;
        DM.M = M;
        DM.N = N;
        DM.u0 = u0;
        DM.uT = uT;
        
        varargin = DM;
        m = 2;
        %         x = randn(2,3*M);
        c1 = c+(rand(numel(c),1)-.5)*max(c)*.5;
        c2 = c+(rand(numel(c),1)-.5)*max(c)*.5;
        cx = [c1,c2]';
        cx_size=size(cx);
        x = cx;
        dim = 3*M;
        
    elseif k == 25
        myfun = @cost_of_heatfunAD;
        rng('default'); rng(13);
        dt = 0.1; dx = 0.05; delta = dt/dx^2; K = 0.5;
        T = 1; N = T/dt;
        L = 1; M = L/dx;
        [A, XO, C, u0, uT] = prepareTestCaseVolaSame(M,N,K);
        
        original_x = size(XO);
        
        clear DM;
        DM.M = M;
        DM.N = N;
        DM.K = K;
        DM.u0 = u0;
        DM.uT = uT;
        
        varargin = DM;
        m = 2;
        c = A;
        c1 = c+(rand(numel(c),1)-.5)*max(c)*.5;
        c2 = c+(rand(numel(c),1)-.5)*max(c)*.5;
        cx = [c1,c2]';
        cx_size=size(cx);
        x = cx;
        dim = 3*M;
        
    elseif k == 26
        myfun = @volafunAD;
        rng('default'); rng(13);
        dt = 0.05; dx = 0.05; delta = dt/dx^2; K = 0.5;
        T = 1; N = T/dt;
        L = 1; M = L/dx;
        [XO, C, u0, uT] = prepareTestCaseVola(M,N,K);
        
        original_x = size(XO);
        
        clear DM;
        DM.M = M;
        DM.N = N;
        DM.K = K;
        DM.u0 = u0;
        DM.uT = uT;
        
        varargin = DM;
        m = 2;
        D1 = (rand(3*M*N,1)-0.5)*max(XO)*.9+XO;
        D2 = (rand(3*M*N,1)-0.5)*max(XO)*.9+XO;
        x = [D1,D2]';
        dx_size = size(x);
        dim = 3*M*N;
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
    for jj=1:m
        xjj_size = size(x(jj,:));
        f(jj)=myfun(x(jj,:),varargin);
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
        
%         display('quasi_newton');
        [fmin2,xmin2,fcount2,gcount]=quasi_newton(myfun,xmin1,varargin);
        [fmin22,~,~,~]=quasi_newton(myfun,x(ind,:)',varargin);
        %         [fmin2,xmin2,fcount2,gcount]=ADforward_QN(myfun,xmin1,varargin);
        
        % 'number of function evaluation in Phase 2',  fcount2
        %'number of gradient evals in Phase 2', gcount
        %'function value of global min (phase 2)', fmin2
    elseif gr_phase2==0
        display('rbftrm')
        ind2=find(fbar_min1==min(fbar_min1));
        [fmin2,xmin2,fcount2]=RBFTRM(myfun,xbar_min1,fbar_min1,ind2,method,deg,gamma,useg,varargin );
        [fmin22,~,~]=RBFTRM(myfun,x,f,ind,method,deg,gamma,useg,varargin);
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
    xmatrix(1:length(xmin1),2*ic)=xmin2;
    
    
    f_ph2(ic)= fmin2;
    it_ph2(ic)= fcount2;
    gNum(ic)= gcount;
    
    if gr_phase2==1
%         display('feval')
        [~,g]=feval(myfun,xmin2,varargin);
        gNorm(ic)= norm(g);
    elseif gr_phase2==0
        gNorm(ic)=NaN;
    end
    f2_value(ic)= fmin22;
    
    ic = ic+1;
    %     if problem == 6;
    %         OUT = [xmin1, xmin2, xmole]
    %     end
    
end

xst=[f_init,f_ph1,f_ph2,f2_value];


TABLE1 = table(ProbNo,fname,Probdim,f_init,f_ph1,it_ph1,f_ph2,...
    it_ph2,gNum,gNorm,f2_value,...
    'VariableNames',{'ProbNo','fname','Probdim','f_init',...
    'f_ph1','it_ph1','f_ph2','it_ph2','gNum','gNorm','f_onlyph2'});
