function[TABLE1,xmatrix,xst] = run_global_RBF_TRM_tt(problem,probstop,gr_phase2,x0,DM,dim)
% special comparision about molecule function
% for problem 20 21 22 23, 24 25 need x0 and DM input

% Run the global optimizer: global_RBF_TRM
% use MATLAB function "fminunc" at phase 2, algorithm is quasi_newton.
% global_RBF_TRM has 2 phases. It is possible to apply phase 1 only

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
%  col11 f2_value :  the function value of phase 2 from initial point
% xmatrix  - - solution x at each phase
%              row size = 50 (> the max dimension)
%              column size = 2*(probstop -problem+1)
%                  For every problem, there are 2 columns
%                  1st column is solution of phase 1
%                  2nd column is solution of phase 2


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
    elseif k ==19
        %transaction cost fucntion
        myfun=@TRcostfun;
        
        %
        m=2;
        
        n=10;
        dim=n;
        mm=10;
        A=rand(n,mm);
        [Q,R]=qr(A);
        D=zeros(n);
        D(1,1)=1;
        condition=10000;
        D(n,n)=1/condition;
        for i=2:n-1
            D(i,i)=(1-1/condition)*rand(1)+1/condition;
        end
        
        H=Q'*D*Q;
        g=-ones(n,1)+2*rand(n,1);
        m_posi = zeros(n,mm);
        k_posi = zeros(n,mm);
        m_nega = zeros(n,mm);
        k_nega = zeros(n,mm);
        epsilon = 0.5;
        
        m_up = 100; m_low = 1;
        for i=1:n
            m_posi(i,:) = m_low + (m_up-m_low)/mm*((rand(1,mm)-0.5)/2+(mm:-1:1));
            k_posi(i,:) = [3,1*(1:mm-1)];
            m_nega(i,:) = -(m_low + (m_up-m_low)/mm*((rand(1,mm)-0.5)/2+(mm:-1:1)));
            k_nega(i,:) = [-3,-1*(1:mm-1)];
        end
        
        % randomly choose x0 from [-1000,1000]^2
        x = 1000*(2*rand(m,n)-1);
        varargin={H,g,epsilon,m_posi,k_posi,m_nega,k_nega};
    elseif k ==20
        
        %%%%%%%%%%%
        % PROBLEM 20 (2-D molecule problem with zero soln) molefd_1f2d
        %%%%%%%%%%%
        myfun=@molefd_1f2d;
        %
        % set the dimension of the problem, dim. Fuinction rast allows for any dimension to be
        % chosen
        %
        %
        % m is the number of initial points used for the radial basis function
        % approx.
        m= 2;
        % determine the inital m points to evaluate the RBF
        lb=-10; ub=10;
        %           x=(-lb+ub).*(2*rand(m,2*dim)-1)/2+(lb+ub)/2;
        x=[x0;x0+1];
        %
        
        % create problem
        DM = mole_2d_case (dim);
        varargin=DM; % a parameter
        dim=2*dim;
        %
    elseif k ==21
        
        %%%%%%%%%%%
        % PROBLEM 18 (2-D molecule problem with zero soln) molefd_1f2d
        %%%%%%%%%%%
        myfun=@new2dmole;
        %
        % set the dimension of the problem, dim. Fuinction rast allows for any dimension to be
        % chosen
        dim =16;
        %
        %
        % m is the number of initial points used for the radial basis function
        % approx.
        m= 2;
        % determine the inital m points to evaluate the RBF
        lb=-10; ub=10;
        %         x0=(-lb+ub).*(2*rand(1,2*dim)-1)/2+(lb+ub)/2;
        %
        DM = mole_2d_case (dim);
        [val,grad,H1] = molefd_1f2d(x0,DM);
        [Y,Z,D] = nullH(H1,10^(-12));
        m2=size(Y,2);
        x=(-lb+ub).*(2*rand(m,m2)-1)/2+(lb+ub)/2;
        % create problem
        
        varargin={DM,x0,Y}; % a parameter
        dim=m2;
        %
    elseif k ==22
        
        %%%%%%%%%%%
        % PROBLEM 22 (2-D molecule problem with zero soln) molefd_1f2d
        %%%%%%%%%%%
        myfun=@molefd_1f2d;
        %
        % set the dimension of the problem, dim. Fuinction rast allows for any dimension to be
        % chosen
        %
        % m is the number of initial points used for the radial basis function
        % approx.
        m= 2;
        % determine the inital m points to evaluate the RBF
        %         lb=-10; ub=10;
        %           x=(-lb+ub).*(2*rand(m,2*dim)-1)/2+(lb+ub)/2;
        x=[x0;x0+1];
        %
        
        % create problem
        % create problem
        varargin=DM; % a parameter
        dim=2*dim;
        %
    elseif k ==23
        
        %%%%%%%%%%%
        % PROBLEM 18 (2-D molecule problem with zero soln) molefd_1f2d
        %%%%%%%%%%%
        myfun=@new2dmole;
        %
        % set the dimension of the problem, dim. Fuinction rast allows for any dimension to be
        % chosen
        % m is the number of initial points used for the radial basis function
        % approx.
        m= 2;
        % determine the inital m points to evaluate the RBF
        lb=-10; ub=10;
        %         x0=(-lb+ub).*(2*rand(1,2*dim)-1)/2+(lb+ub)/2;
        %
        [val,grad,H1] = molefd_1f2d(x0,DM);
        [Y,Z,D] = nullH(H1,10^(-12));
        m2=size(Y,2);
        x=(-lb+ub).*(2*rand(m,m2)-1)/2+(lb+ub)/2;
        % create problem
        
        varargin={DM,x0,Y}; % a parameter
        dim=m2;
    elseif k ==24
        
        %%%%%%%%%%%
        % PROBLEM 24 (3-D molecule problem with zero soln) molefd_1f3d
        %%%%%%%%%%%
        myfun=@molefd_1f3d;
        %
        % set the dimension of the problem, dim. Fuinction rast allows for any dimension to be
        % chosen
        %
        % m is the number of initial points used for the radial basis function
        % approx.
        m= 2;
        % determine the inital m points to evaluate the RBF
        %         lb=-10; ub=10;
        %           x=(-lb+ub).*(2*rand(m,2*dim)-1)/2+(lb+ub)/2;
        x=[x0;x0+1];
        %
        
        % create problem
        % create problem
        varargin=DM; % a parameter
        dim=3*dim;
        %
    elseif k ==25
        
        %%%%%%%%%%%
        % PROBLEM 25 (3-D molecule problem with zero soln) molefd_1f3d
        %%%%%%%%%%%
        myfun=@new3dmole;
        %
        % set the dimension of the problem, dim. Fuinction rast allows for any dimension to be
        % chosen
        %
        % m is the number of initial points used for the radial basis function
        % approx.
        m= 2;
        % determine the inital m points to evaluate the RBF
        lb=-10; ub=10;
        %         x0=(-lb+ub).*(2*rand(1,2*dim)-1)/2+(lb+ub)/2;
        %
        
        [val,grad,H1] = molefd_1f3d(x0,DM);
        [Y,Z,D] = nullH(H1,10^(-12));
        m2=size(Y,2);
        x=(-lb+ub).*(2*rand(m,m2)-1)/2+(lb+ub)/2;
        % create problem
        
        varargin={DM,x0,Y}; % a parameter
        dim=m2;
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
    %     ind=find(f==min(f));
    ind=1;
    
    xst=x(ind,:);
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
        
        
        [fmin2,xmin2,fcount2,gcount]=quasi_newton(myfun,xmin1,varargin);
        [fmin22,~,~,~]=quasi_newton(myfun,x(ind,:)',varargin);
        %         [fmin2,xmin2,fcount2,gcount]=ADforward_QN(myfun,xmin1,varargin);
        
        % 'number of function evaluation in Phase 2',  fcount2
        %'number of gradient evals in Phase 2', gcount
        %'function value of global min (phase 2)', fmin2
    elseif gr_phase2==0
        
        ind2=find(fbar_min1==min(fbar_min1));
        [fmin2,xmin2,fcount2]=RBFTRM(myfun,xbar_min1,fbar_min1,ind2,method,deg,gamma,useg,varargin );
        [fmin22,~,~]=RBFTRM(myfun,x,f,ind,method,deg,gamma,useg,varargin );
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
    
    
    if k==21;% specail 2-D structure
        xst=x0';
        xe1=Y*xmin1+x0';
        xmatrix(1:length(x0),2*ic-1)=xe1;
        xend=Y*xmin2+x0';
        xmatrix(1:length(x0),2*ic)=xend;
        
    end
    
    
    f_ph2(ic)= fmin2;
    it_ph2(ic)= fcount2;
    gNum(ic)= gcount;
    
    if gr_phase2==1
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


TABLE1 = table(ProbNo,fname,Probdim,f_init,f_ph1,it_ph1,f_ph2,...
    it_ph2,gNum,gNorm,f2_value,...
    'VariableNames',{'ProbNo','fname','Probdim','f_init',...
    'f_ph1','it_ph1','f_ph2','it_ph2','gNum','gNorm','f2_value'});
