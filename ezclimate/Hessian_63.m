file = input('What is the name of the file?','s');
sample = input('What is the sample number?');
name = input('What is the name of the optimal mitigation?');
count = input('How many tests do you want?');
load(file);
m0 = name(:,sample);
%multiprocessing_setup();
varargin = py.Matlabmod.matlabmode(-1);
myfun = @matlab_utility;
noise = normrnd(0,0.3,[63,count]);
m_add = noise + repmat(m0,1,count);
m_summary = [m0,m_add];
m_summary(m_summary<0)=0;
timer = [];
file_save = 'hessian_63.xlsx';
for i = 1:count+1
   profile on
   hessian = NumHessian(myfun,m_summary(:,i),varargin); 
   [~,num]=cholcov(hessian,0);
   if num ~= 0
       disp(['No.','',num2str(i),'',' is not positive definite.']);
   end
   save(['hessian_63_','',num2str(sample),'','_','',num2str(i)]);
   xlswrite(file_save, hessian, i);
   warning('off','MATLAB:xlswrite:AddSheet')
   profile off
   time = profile('info');
   timer = [timer;time.FunctionTable];
end
