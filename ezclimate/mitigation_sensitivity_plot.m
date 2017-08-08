file= input('What is the name of the file? ','s');
load(file)
name = input('What is the name of the mitigation variable? ');
x_change = input('What is the x to change?');
step = input('What is the stepsize? ');
count = input('How many steps would you like? ');
m = name;
m_summary = repmat(m,1,2*count+1);
m_change = linspace(m(x_change)-step*count,m(x_change)+step*count,2*count+1);
m_summary(x_change,:) = m_change;
u_summary = zeros(1,2*count+1);
%multiprocessing_setup();
varargin = py.Matlabmod.matlabmode(-1);
for i = 1:2*count+1
    u_summary(1,i) = matlab_utility(m_summary(:,i),varargin);
end
fig = plot(m_change,u_summary);
title(['Utilities for Mitigation Changes at Node ','',num2str(x_change)]);
ylabel('Utilities');
xlabel(['Mitigation Level at Node ', '', num2str(x_change)]);
u_summary = [u_summary,std(u_summary,1,2),'LineWidth',2];
saveas(fig,['Utilities for Mitigation Changes at Node ','',num2str(x_change)],'epsc');
save(['results_for_plot_','',num2str(x_change)]);