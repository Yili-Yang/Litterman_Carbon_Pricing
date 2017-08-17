import matplotlib.pyplot as plt
import scipy.io as sio
import pickle
import numpy as np
from tree import TreeModel

def get_ave_price(price,decision_times): #period average for each sample
    t = TreeModel(decision_times)
    nodes_index = []
    for i in range(t.num_periods): #get nodes for slicing
        nodes_index.append(t.get_nodes_in_period(i)) 
    period_price_ave = np.zeros((price.shape[1], t.num_periods))
    for i in range(price.shape[1]):  #calculate the period average for each sample
        for j in range(t.num_periods):
            period_price_ave[i][j] = np.average(price[:,i][nodes_index[j][0]:nodes_index[j][1]+1])
    return period_price_ave

def get_90_quantile(period_price_ave): #5% and 95% percentiles for all the samples
    list0 = period_price_ave[:,0]
    list1 = period_price_ave[:,1]
    list2 = period_price_ave[:,2]
    list3 = period_price_ave[:,3]
    list4 = period_price_ave[:,4]
    list5 = period_price_ave[:,5]
    list_ = [list0,list1,list2,list3,list4,list5]
    fivepercent = int(len(list0)*0.05)
    for i in range(len(list_)):
        list_[i]=np.sort(list_[i])[fivepercent:-fivepercent] #take the 90% of the sorted results
    list_min = []
    list_max = []
    for i in list_:
        list_min.append(i[0])
        list_max.append(i[-1])   
    return list_min,list_max #take the lower and upper bounds for the test results

def draw_graph(ind)
	decision_times=[0, 15, 45, 85, 185, 285, 385]
	name_list = ['alpha450','alpha650','alpha1000','beta450','beta650','beta1000','theta450','theta650','theta1000']
	#load results stored in matlab
	data = sio.loadmat('sensitivity_result_%s.mat'.format(ind)) #change the name of the file to read
	data_base = sio.loadmat('sensitivity_base_results.mat')
	p = np.array(-data['price_summary'])
	# m = np.array(data['mitigation_summary'])
	iteration = np.array(data['iteration_summary'])
	u = np.array(-data['utility_summary'])
	# u_node = np.array(-data['utility_node_summary'])
	norm = np.array(data['final_norm_g_QN_summary'])
	# fcount = np.array(data['fcount_summary'])
	p_base = np.array(data_base['price_m_t'])

	#get the period average and 2 boundaries with get_ave_price and get_90_quantile
	period_price_ave = get_ave_price(p, decision_times)
	period_price_base = get_ave_price(p_base,decision_times)
	period_price_base = -np.mean(period_price_base,axis=0)
	list_min,list_max = get_90_quantile(period_price_ave)

	fig, (ax, tabay, tabax) = plt.subplots(nrows=3, figsize=(10,8))
	#draw the subplot with the sample average and the 2 boundaries
	ax.plot(decision_times[:-1],list_min, 'r--', 
	        decision_times[:-1],list_max, 'r--',
	        decision_times[:-1],period_price_base,'b')
	ax.set_title("Sensitivity Analysis for Parameter %s".format(name_list[ind-1]), size ='xx-large')
	ax.set_ylabel('Price in $', size = 'x-large')
	ax.set_xlabel('Period Index', size = 'x-large')

	#draw the table with the samples' period average
	tabay.axis("off")
	columns_price = ['In %d Years' %x for x in decision_times]
	row_label_price = ['Expected Price']
	cell_text_price = np.zeros([1,len(period_price_ave[0,:])])
	cell_text_price[0] = np.average(period_price_ave,0)
	the_table_price = tabay.table(cellText=cell_text_price,
	                             rowLabels=row_label_price,
	                             colLabels=columns_price)
	the_table_price.set_fontsize(38)
	the_table_price.scale(1,2)

	#draw the table with the average of some parameters 
	tabax.axis("off")
	columns = ['Iteration Number','Utility at Start Point', 'Norm of Gradient'] #define the parameters
	row_label = ['Average of %d Tests' %p.shape[1]] #define the label/content of the rows
	rows = len(row_label) 
	cell_text = np.zeros([1,len(columns)]) #define the content of the table
	#append the cell_text if you want to display the information of all the inividual samples
	#for row in range(len(norm)):
	    #cell_text[row,:]=[iteration[row],u[row],norm[row]]
	cell_text[0,:] = [np.average(iteration),np.average(u),np.average(norm)]

	the_table = tabax.table(cellText=cell_text,
	                  rowLabels=row_label,
	                  #rowColours=colors,
	                  colLabels=columns,
	                       loc = 'bottom')#define the table
	the_table.set_fontsize(34)
	the_table.scale(1, 2)

	#save the figure
	fig.savefig('sensitivity_result_%s.png'.format(ind),bbox_inches='tight')#change the name of the figure here
	plt.show()