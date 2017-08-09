%ask for the file name, use a random point if not specified
file= input('What is the name of the file? ','s');
if file == 'random'
    name = rand([63 1]);
else 
    load(file)
    name = input('What is the name of the mitigation variable? ');
end
%file = 'sensitivity_base/sensitivity_base_6.mat';

%ask for the node to change and the scale of change
%x_change = input('What is the x to change?');
step = input('What is the stepsize? ');
count = input('How many steps would you like? ');

%modify m and create a matrix for mitigation level m_summary
m = name;
m_summary = repmat(m,1,2*count+1);
% m_change = linspace(m(x_change)-step*count,m(x_change)+step*count,2*count+1);
% m_summary(x_change,:) = m_change;
% u_summary = zeros(1,2*count+1);
%multiprocessing_setup();
varargin = py.Matlabmod.matlabmode(-1);
for j = 1:63
    u_summary = zeros(1,2*count+1);
    m_change = linspace(m(j)-step*count,m(j)+step*count,2*count+1);
    m_new = m_summary;
    m_new(j,:) = m_change;
    for i = 1:2*count+1
    u_summary(1,i) = matlab_utility(m_new(:,i),varargin);
    end
    fig = plot(m_change,u_summary);
    title(['Utilities for Mitigation Changes at Node ','',num2str(j),'',' for a Random Point']);
    ylabel('Utilities');
    xlabel(['Mitigation Level at Node ', '', num2str(j)]);
    u_summary = [u_summary,std(u_summary,1,2)];
    saveas(fig,['Utilities for Mitigation Changes at Node ','',num2str(j),'',' for a Random Point'],'epsc');
    save(['results_for_plot_','',num2str(j),'','_random']);
end


% %calculate the utilities for each point
% for i = 1:2*count+1
%     u_summary(1,i) = matlab_utility(m_summary(:,i),varargin);
% end
% 
% %produce the plot and save it
% fig = plot(m_change,u_summary);
% title(['Utilities for Mitigation Changes at Node ','',num2str(x_change),'',' for a Random Point']);
% ylabel('Utilities');
% xlabel(['Mitigation Level at Node ', '', num2str(x_change)]);
% u_summary = [u_summary,std(u_summary,1,2),'LineWidth',2];
% saveas(fig,['Utilities for Mitigation Changes at Node ','',num2str(x_change),'',' for a Random Point'],'epsc');
% save(['results_for_plot_','',num2str(x_change),'','_random']);