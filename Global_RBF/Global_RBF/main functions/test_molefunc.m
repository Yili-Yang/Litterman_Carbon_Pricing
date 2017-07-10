%test_molefunc
%same x0 and DM to run different molecule problems
% the new problem remove rotation and the length of solution is shorter

n=100;
dim=n;
lb=-10; ub=10;
% x0=(-lb+ub).*(2*rand(1,2*dim)-1)/2+(lb+ub)/2;%2d
x0=(-lb+ub).*(2*rand(1,3*dim)-1)/2+(lb+ub)/2;%3d
% case one special structure
% dim=2,3,4,6,8,16

% [TABLE1,xmatrix,xst] = run_global_RBF_TRM(20,20,1,x0);
% % err=plot2d_case(n,xmatrix,xst);
% [TABLE11,xmatrix1,xst1] = run_global_RBF_TRM(21,21,1,x0);
% % err=plot2d_case(n,xmatrix1,xst1);

% case two, ordinary structure
% perc_nnz=0.75;
% [ DM, xmole,ymole,xstar] = make_mole_2d (perc_nnz,dim);
% [TABLE1,xmatrix,xst] = run_global_RBF_TRM_tt(22,23,1,x0,DM,dim); %2d
% 
perc_nnz=0.05;
[ DM, xmole,ymole,xstar] = make_mole_3d (perc_nnz,dim);
[TABLE1,xmatrix,xst] = run_global_RBF_TRM_tt(24,25,1,x0,DM,dim); %3d