multiprocessing_setup()
%sub_opt_m = ones(1,59);
%sub_opt_m = [0,0,0,0,sub_opt_m];
%opt_m = ones(1,63);
load('subopt_opt_m')
z = 0;
pyclass = py.Matlabmod.matlabmode(-1);
diff =2;
iter_count = 0;
fcount_m = [];
iter_QN_m = [];
fmin_m =[];
z_m = [];
profile on
fun = @matlab_utility_g_sub_optimal_case2;
while norm(diff) > 1e-5
    obj_function = @(z)cons_search(z,opt_m,pyclass) - matlab_utility(sub_opt_m',pyclass);
    z_m = [z_m;z];
    if z > -1
        z = fzero(obj_function,z);
    else
        z = -1;
    end
    [fmin,opt_m_new,fcount,~,iter] = Quasi_Newton(fun,opt_m',z,pyclass);
    fmin_m = [fmin_m;fmin];
    fcount_m = [fcount_m;fcount];
    iter_QN_m = [iter_QN_m;iter];
    diff = opt_m_new-opt_m';
    opt_m = opt_m_new';
    disp('diff')
    disp(norm(diff))
    iter_count = iter_count + 1;
end
profile off
profsave(profile('info'),'sub_opt_case2_info_2')
save('sub_opt_case2_test2')

