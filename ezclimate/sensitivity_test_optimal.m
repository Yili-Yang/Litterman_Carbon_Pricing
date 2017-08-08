file= input('What is the name of the file?');
mitigation = input('What is the name of the mitigation variable?');
data = load(file);
m0 = mitigation;
utility_summary = zeros(length(m0),100);
multiprocessing_setup();
varargin = py.Matlabmod.matlabmode(-1);
u0 = matlab_utility(m0,varargin);
for i = 1:length(m0)
    x = normrnd(0,0.05,[10,1]);
    m_new =repmat(m0,1,length(x));
    m_new(i,:) = m_new(i,:)+x.';
    for j = 1:length(x)
        m_ind = m_new(:,j);
        utility_summary(i,j)=matlab_utility(m_ind,varargin);
    end
end
utility_summary = [utility_summary,std(utility_summary,1,2)];
save('sensitivity_test_around_optimal_solution');