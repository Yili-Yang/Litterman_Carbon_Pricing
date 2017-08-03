file= input('What is the name of the file?','s');
mitigation = input('What is the name of the mitigation variable?');
change = input('Please enter the index of mitigation levels that you want to test:');
data = load(file);
m0 = mitigation;
utility_summary = zeros(1,100);
multiprocessing_setup();
varargin = py.Matlabmod.matlabmode(-1);
u0 = matlab_utility(m0,varargin);
noise = normrnd(0,0.05,[length(change),100]);
m_new = repmat(m0,100);
for i = 1:length(change)
    m_new(change(i),:) = noise(i,:);
end
for count = 1:100 %this part could be improved by fixing the unchanged part
    utility_summary(1,count) = matlab_utility(m_new(:,count),varargin);
end
utility_summary = [utility_summary, std(utility_summary,1,2)];
save('sensitivity_test_around_optimal_solution_multiple');