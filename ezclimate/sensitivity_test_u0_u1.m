file1= input('What is the name of the first file?','s');
load(file1)
name_1 = input('What is the name of mitigation1?');
m1 = name_1;
file2= input('What is the name of the second file?','s');
load(file2)
name_2 = input('What is the name of mitigation2?');
m2 = name_2;
count = input('How many evaluations do you want?');
m_summary = zeros(63,count+2);
u_summary = zeros(1,count+2);
multiprocessing_setup();
varargin = py.Matlabmod.matlabmode(-1);
for i = 1:length(m1)
    m_summary(i,:) = linspace(m1(i),m2(i),count+2);
end
for j = 1:count+2
    u_summary(1,j) = matlab_utility(m_summary(:,j),varargin);
end
u_summary = [u_summary,std(u_summary,1,2)];
save('linear spaced utility test');