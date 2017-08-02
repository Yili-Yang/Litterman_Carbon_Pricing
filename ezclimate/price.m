multiprocessing_setup() % set up multiprocessing package, manully call the exectuable of python
varargin = py.Matlabmod.matlabmode(-1); 
for count = 1:20
    profile on 
    [x] = matlab_utility(ones(1,63)',varargin);
    
    k = profile('info');
    ans = k.FunctionTable.TotalTime
    profile off
end
