%ask for the file name, mitigation variable, and nodes to change
file = input('What is the name of the file? ', 's');
if file ~= 'random'
    load(file);
    name = input('What is the name of the mitigation variable? ');
end
x_change = input('Which 2 x are to be changed? ');
x_change_1 = x_change(1);
x_change_2 = x_change(2);
%set up the scale of change
step = input('What is the stepsize? ');
count = input('How many steps would you like? ');
m = name(:,1);
m_change_1 = linspace(m(x_change_1)-step*count, m(x_change_1)+step*count,2*count+1);
m_change_2 = linspace(m(x_change_2)-step*count, m(x_change_2)+step*count,2*count+1);                
u_summary = zeros(2*count+1);
%multiprocessing_setup();
varargin = py.Matlabmod.matlabmode(-1);
timer = [];
%for each change in dimension 1, generate the mitigations under change in
%dimension 2 and calculate corresponding utilities.
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
save(['Utilities with Mitigation Changes at Node ','',num2str(x_change_1),'',' and Node ','',num2str(x_change_2),'',' for a Random Point']);
%generate 3-d picture
figure
fig = surf(m_change_1,m_change_2,u_summary);
title(['Utilities with Mitigation Changes at Node ','',num2str(x_change_1),'',' and Node ','',num2str(x_change_2),'',' for a Random Point']);
xlabel(['Mitigation Level at Node ','',num2str(x_change_2)]);
ylabel(['Mitigation Level at Node ','',num2str(x_change_1)]);
zlabel('Utility');
hold on
%mark the original point
scatter3(m_change_1(count+1),m_change_2(count+1),u_summary(count+1,count+1),'filled','y');
saveas(fig,['Utilities with Mitigation Changes at Node ','',num2str(x_change_1),'',' and Node ','',num2str(x_change_2),'',' for a Random Point'],'epsc')
hold off