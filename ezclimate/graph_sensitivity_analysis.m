function graph_sensitivity_analysis(result_number)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%           Yili Yang, Aug 2017
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Draw the graphs for sensitivity analysis
%
% Input:
% result_number - index of the sensitivity result that you want to draw the
% graph
%
% Output:
% a png file in sensitivity_analysis_results folder
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load the sensitivity results
load(['sensitivity_analysis_results\sensitivity_result_','',num2str(result_number),'','.mat'])
load('sensitivity_analysis_results\sensitivity_base_results.mat')
name_cell = {'alpha450', 'alpha650', 'alpha1000', 'beta450', 'beta650', 'beta1000', 'theta450', 'theta650', 'theta1000', 'nothing is changed', 'x60','x100'};

% Take the average price of each node within one period to draw the graph
% Since each node within one period has the same probability, the expected
% value is the average.
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
% take 90% quantile
bound = -prctile(period_price_ave,[5,95],2);
decision_time = [0, 15, 45, 85, 185, 285]';
% plot the figure
figure_m = figure;
plot(decision_time,price_base,'b',decision_time,bound,'r--')

title(['Sensitivity Analysis for Parameter',' ',name_cell{result_number}])
xlabel('Period')
ylabel('Price in $')
saveas(figure_m,['sensitivity_analysis_results\Sensitivity Analysis for Parameter',' ',name_cell{result_number},'.png'])
end