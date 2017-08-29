%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%           Yili Yang, Aug 2017
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Return the hessian matrix at random points.
%
% Outputs: 
% number of negative eigenvalue of the sysmtric hessian matrix at random
% points. default number of test is 8.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
number_test =8;
multiprocessing_setup();
varargin = py.Matlabmod.matlabmode(-1);
myfun = @matlab_utility;

timer = [];
condition_m = [];
num_m = [];
hessian_m = [];
mitigation_m =[];
for j = 1:number_test
    m_optimal = rand(1,63)';
    mitigation_m = [mitigation_m,m_optimal];
    profile on
    hessian = NumHessian(myfun,m_optimal,varargin); 
    hessian_m = [hessian_m;hessian];
    sym = (hessian+hessian')/2;
    [~,num]=cholcov(sym,1);
    num_m = [num_m; num];
    condition_m = [condition_m;cond(sym)];
    display(num);
    if num ~= 0
         disp(['Sample','',num2str(j),'',' is not positive definite.']);
    end
    profile off
    time = profile('info');
    timer = [timer;time.FunctionTable];
end
magnitude_m = [];
for i =1:number_test
    start_i = int16((i-1)*63)+1;
    end_i = int16(i*63);
    result_h = hessian_m(start_i:end_i,:);
    e = eig(result_h);
    re_e = e(e<0);
    magnitude_m = [magnitude_m;norm(re_e)];
end
save(['hessian_random_with_sample_','',num2str(number_test)]);

