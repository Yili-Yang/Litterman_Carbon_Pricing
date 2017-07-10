function Gmatrix= test_gradient(problem,probstop)
%
% Run the global optimizer: global_RBF_TRM
% test gradient after phase 1
%
% INPUT
%
% problem: the problem #to start at
% probstop: the problem # to stop at
%

%
% output
%
%
% Gmatrix  - - gradient
%              row size = 50 (> the max dimension)
%              column size = 3*(probstop -problem+1)
%                  For every problem, there are 3 columns
%                  1st column is computed by gradient code
%                  2nd column is  computed by AD forward mode
%                  3rd column is  computed by AD reverse mode
%

if nargin < 2, probstop = problem; end
if nargin <1, problem = 1; end


Gmatrix=zeros(50,3*(probstop -problem+1));

% Solve the problems
ic=1;
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
        
        %%%%%%%%%%%
        % PROBLEM 18 (2-D molecule problem with zero soln) molefd_1f2d
        %%%%%%%%%%%
        myfun=@mole_pd;
        %
        % set the dimension of the problem, dim. Fuinction rast allows for any dimension to be
        % chosen
        dim = 10;
        p=2;
        %
        %
        % m is the number of initial points used for the radial basis function
        % approx.
        m= 2;
        % determine the inital m points to evaluate the RBF
        lb=-10; ub=10;
        x=(-lb+ub).*(2*rand(m,p*dim)-1)/2+(lb+ub)/2;
        %
        % create problem
        perc_nnz=0.75;
        [ DM, xxmole] = make_mole_pd (p,perc_nnz,dim);
        varargin=DM; % a parameter
        dim = p*dim;
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%END OF PROBLEM SET-UP
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
    
 
    [~,g1]=feval(myfun,xmin1,varargin);
   
   
    n=length(xmin1);
    options = setgradopt('forwprod', n);
    myfun1 = ADfun(func2str(myfun), 1);
    [~,g2] = feval(myfun1, xmin1,varargin,options);
    g2=g2';
    
    options1= setgradopt('revprod', n);
    [~,g3]= feval(myfun1,xmin1,varargin,options1);

     Gmatrix(1:n,3*ic-2)=g1;
    Gmatrix(1:n,3*ic-1)=g2;
     Gmatrix(1:n,3*ic)=g3;
    ic=ic+1;
    
end