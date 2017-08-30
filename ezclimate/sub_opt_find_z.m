
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%           Yili Yang, July 2017
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Find z in Suboptimal Strategy's equation (2.3).
% we first fix x in (2.3) then increasing z to make the equation hold, then
% do the maximizing, to get a xstar w.r.t. c0-z (now the J(c0-z) will be 
% larger than the sub-opt) then fix xstar, increase z to make the equation
% hold then do max... and we are in a loop. The stop constraint is set to 
% be the difference between the mitigation level before and after the 
% optimization process. If the norm of difference is smaller that 1e-5, 
% then we consider these two solution as the same and thus should stop 
% updating z. Starting with z = 0 .
%
% Inputs:
% ind: the indicator of what parameters is been changed.
%   1. = -1: use original parameters and fixed seed to simulate damage 
%   2. = 0~8: change the parameters in pindyck damage simulation, 0 is to 
%             change alpha450, 1 is to change alpha650 ... 8 is to change
%             theta1000
%   3. = 9: use orignal parameters and random seed to simulate damage
%   4. = 10 or 11: change the parameters in cost function, 10 is to change
%                  x60 and 11 is to change x100
% mitigation_0: mitigation level matrix of one period that is fixed 
% at the beginning. For period 0 there is only one to change so that the
% input should be [n], for period 1 it should be [n1,n2] and for period 2
% it should be [n1,n2,n3,n4]...
% sampleind: unique sample ind to allow saving multiple tests results for
% the same parameter setting
% pos: position where the mitigation will be fixed. The position refers to
% the number of nodes of the period i.e. if you want to change period 0
% then input [0], for period 1 input [1 1] since they are inserted after the
% first node, and for period 2 input [3 3 3 3] since there are 3 nodes
% ahead.
% To change a single node's mitigation with a single period, the position will be the number of
% nodes head, for example, to change the 'down' node of period one, the pos
% should be [2], to change 'dd' node on period 2, pos should be [6]
% And now for mitigation level at anytime, we can change it. For example:
% [2,2,2,3] changes 'd','uu','ud','dd' 
% you can find more reference in the document of numpy.insert(array,[pos],[value]) 
%
% 
% Output:
% z : z value of equation (2.3)
% Other varaibles for analysis is saved to a mat file including:
% z_m : z value after each optimization process
% fmin_m: function value after each optimization process
% founct_m : number of function evaluation in each optimization process
% iter_QN_m : number of iteration number in each optimization process
% norm_g_m : norm of gradient after each optimization
% opt_m_r : optimal mitigation level after each optimization
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function z = sub_opt_find_z(ind,mitigation_0,sampleind,pos,opt_mitigation)

[~,xmin2,~,~,~,~,~,~] = find_sub_optimal(ind,mitigation_0,sampleind,pos);
sub_opt_m = xmin2';
%load('opt_m')
multiprocessing_setup()
%sub_opt_m = ones(1,59);
%sub_opt_m = [0,0,0,0,sub_opt_m];
opt_m = opt_mitigation;
z = 0;
pyclass = py.Matlabmod.matlabmode(-1);
diff =2;
iter_count = 0;
fcount_m = [];
iter_QN_m = [];
fmin_m =[];
z_m = [];
norm_g_m =[];
opt_m_r =[];
profile on
fun = @matlab_utility_g_sub_optimal_case2;
target = matlab_utility(sub_opt_m',pyclass);
while (norm(diff) > 1e-5)
    obj_function = @(z)(-cons_search(z,opt_m,pyclass) + target)^2;
    z = fminbnd(obj_function,-1,0);
    z_m = [z_m;z];
    opt_m_r = [opt_m_r;opt_m];
    [fmin,opt_m_new,fcount,~,iter] = Quasi_Newton(fun,opt_m',z,pyclass);
    fmin_m = [fmin_m;fmin];
    fcount_m = [fcount_m;fcount];
    iter_QN_m = [iter_QN_m;iter];
    [~,g] = matlab_utility_g_sub_optimal_case2(opt_m_new,z,pyclass);
    norm_g_m = [norm_g_m;norm(g)];
    diff = opt_m_new-opt_m';
    opt_m = opt_m_new';
    disp('diff')
    disp(norm(diff))
    iter_count = iter_count + 1;
end
profile off
profsave(profile('info'),['sub_opt_case2_info_pos_1_','',num2str(mitigation_0*100)])
save(['sub_opt_case2_pos_1_','',num2str(mitigation_0*100)])
end


