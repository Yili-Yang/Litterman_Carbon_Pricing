file = input('What is the name of the file?','s');
name = input('What is the name of the optimal mitigation?');
count = input('How many tests do you want?');
load(file);
m0 = name;
%multiprocessing_setup();
varargin = py.Matlabmod.matlabmode(-1);
myfun = @matlab_utility;
noise = normrnd(0,0.3,[63,count]);
m_add = noise + repmat(m0,1,count);
m_summary = [m0,m_add];
m_summary(m_summary<0)=0;
timer = [];
for i = 1:count+1
   profile on
   hessian = NumHessian(myfun,m_summary(:,i),varargin); 
   save(['hessian_63_','',num2str(i)]);
   profile off
   time = profile('info');
   timer = [timer;time.FunctionTabel];
end
