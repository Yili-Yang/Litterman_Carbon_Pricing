%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%           Yili Yang, Aug 2017
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% use the optimial result acquired by QN and test the convexity around the
% optimal point.
% Input: 
% number of samples that need to be tested
% optimial mitigation level
% Output:
% hessian matrix before symmatring 
% number of negative eigenvalues
% time of each run
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
file = input('What is the name of the file? ','s');
load(file)
sample = input('How many samples should we test? ');
name = input('What is the name of the optimal mitigation? ');
multiprocessing_setup();
varargin = py.Matlabmod.matlabmode(-1);
myfun = @matlab_utility;
timer = [];
condition_m = [];
num_m = [];
hessian_m = [];
for j = 1:sample
    m_optimal = name(:,sample);
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
for neg = num(num>0)
    start_i = int16((neg-1)*63)+1;
    end_i = int16(neg*63);
    result_h = hessian_m(start_i:end_i,:);
    e = eig(result_h);
    re_e = e(e<0);
    magnitude_m = [magnitude_m;norm(re_e)];
end
save(['hessian_optimal_with_sample_','',num2str(sample)]);