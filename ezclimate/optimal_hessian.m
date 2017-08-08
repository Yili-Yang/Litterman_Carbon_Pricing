file = input('What is the name of the file? ','s');
sample = input('How many samples should we test? ');
name = input('What is the name of the optimal mitigation? ');
load(file);
for j = 1:sample
    m_optimal = name(:,sample);
    %multiprocessing_setup();
    varargin = py.Matlabmod.matlabmode(-1);
    myfun = @matlab_utility;
    timer = [];
    profile on
    hessian = NumHessian(myfun,m_optimal,varargin); 
    sym = (hessian+hessian')/2;
    [~,num]=cholcov(sym,0);
    display(num);
    if num ~= 0
         disp(['Sample','',num2str(j),'',' is not positive definite.']);
    end
    save(['hessian_optimal_','',num2str(j)]);
    profile off
    time = profile('info');
    timer = [timer;time.FunctionTable];
end

