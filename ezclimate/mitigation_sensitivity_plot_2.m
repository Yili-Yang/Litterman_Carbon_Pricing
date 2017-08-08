file = input('What is the name of the file? ', 's');
load(file);
name = input('What is the name of the mitigation variable? ');
x_change = input('Which 2 x are to be changed? ');
x_change_1 = x_change(1);
x_change_2 = x_change(2);
step = input('What is the stepsize? ');
count = input('How many steps would you like? ');
m = name(:,1);
m_change_1 = linspace(m(x_change_1)-step*count, m(x_change_1)+step*count,2*count+1);
m_change_2 = linspace(m(x_change_2)-step*count, m(x_change_2)+step*count,2*count+1);                
u_summary = zeros(2*count+1);
%multiprocessing_setup();
varargin = py.Matlabmod.matlabmode(-1);
timer = [];
for i = 1:2*count+1
    profile on
    m_temp = repmat(m,1,2*count+1);
    m_temp(x_change_1,:) = ones(1,2*count+1)*m_change_1(i);
    m_temp(x_change_2,:) = m_change_2;
    m_temp(m_temp<0)=0;
    for j = 1:2*count+1
        u_summary(i,j) = matlab_utility(m_temp(:,j),varargin);
    end
    profile off
    time = profile('info');
    timer = [timer;time.FunctionTable];
end
save(['Utilities with Mitigation Changes at Node ','',num2str(x_change_1),'','and Node ','',num2str(x_change_2)]);
figure
fig = surf(m_change_1,m_change_2,u_summary);
title(['Utilities with Mitigation Changes at Node ','',num2str(x_change_1),'','and Node ','',num2str(x_change_2)]);
xlabel(['Mitigation Change at Node ','',num2str(x_change_1)]);
ylabel(['Mitigation Change at Node ','',num2str(x_change_2)]);
zlabel('Utility');
hold on
original = scatter3(m(x_change_1),m(x_change_2),u_summary(x_change_1,x_change_2),'filled','y');
saveas(fig,['Utilities with Mitigation Changes at Node ','',num2str(x_change_1),'',' and Node ','',num2str(x_change_2)],'epsc')
hold off