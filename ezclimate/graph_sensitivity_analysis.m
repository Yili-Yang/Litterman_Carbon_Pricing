function graph_sensitivity_analysis(result_number)

load(['sensitivity_analysis_results\sensitivity_result_','',num2str(result_number),'','.mat'])
load('sensitivity_analysis_results\sensitivity_base_results.mat')
name_cell = {'alpha450', 'alpha650', 'alpha1000', 'beta450', 'beta650', 'beta1000', 'theta450', 'theta650', 'theta1000', 'nothing is changed', 'x60','x100'};
period_price_ave = [];
for i =1:6
    start_i = 2^(i-1);
    end_i = 2^(i)-1;
    period_price_ave = [period_price_ave;mean(price_summary(start_i:end_i,:),1)];
end
period_price_ave_base = [];
for i =1:6
    start_i = 2^(i-1);
    end_i = 2^(i)-1;
    period_price_ave_base = [period_price_ave_base;mean(price_m_t(start_i:end_i,:),1)];
end
price_base = -mean(period_price_ave_base,2);
bound = -prctile(period_price_ave,[10,90],2);
decision_time = [0, 15, 45, 85, 185, 285]';
plot(decision_time,price_base,'b',decision_time,bound,'r--')

title(['Sensitivity Analysis for parameter',' ',name_cell{result_number}])
xlabel('period')
ylabel('price in $')
end