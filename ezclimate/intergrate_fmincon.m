utility_fmincon = [];
norm_g=[];
utility=[];
iter=[];
count_utility=[];
exit_flags = [];
m=[];
multiprocessing_setup() % set up multiprocessing package, manully call the exectuable of python
varargin = py.Matlabmod.matlabmode(9); % init the class in Matlabmode_g
for count = 26:30
profile on
m_in_mat_0 = rand(1,63)';
f_fun = @(x)matlab_utility(x,varargin);
%options = optimoptions(@fmincon,'StepTolerance', 1e-20,'SpecifyObjectiveGradient',true);
options = optimoptions(@fmincon,'StepTolerance', 1e-10);
[x,fval,exitflag,output,lambda,grad,hessian]= fmincon(f_fun,m_in_mat_0,eye(63,63),2*ones(1,63),[],[],[],[],[],options);% run Quasi_Newton loacl optimizer
save(['fmincon/fmincon_fix_','',num2str(count)])
utility_fmincon(end+1) = fval;
norm_g(end+1) = norm(grad); 
iter(end+1) = output.iterations;
count_utility(end+1) = output.funcCount;
exit_flags(end+1) = exitflag;
m = [m, x];
profile off
profsave(profile('info'),['fmincon/fmincon_profile_','',num2str(count)])
timer = profile('info');
time_structure = timer.FunctionTable.TotalTime;
end
save('fmincon/fmincon_21_25')