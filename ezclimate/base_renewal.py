# -*- coding: utf-8 -*-
"""
Created on Wed Jul 05 10:47:47 2017

@author: matlabyy
"""

# -*- coding: utf-8 -*-
"""
Created on Tue Jun 20 10:26:46 2017

@author: matlabyy
"""

# -*- coding: utf-8 -*-
"""
Created on Fri Jun 16 15:16:44 2017

@author: Ted Yang
"""

import datetime as dt
from tree import TreeModel
from bau import DLWBusinessAsUsual
from cost import DLWCost
from damage import DLWDamage
from utility import EZUtility
from optimization import GeneticAlgorithm, GradientSearch
import numpy as np
import pickle
def base_case():
    time_list =list()
    print('Start',dt.datetime.time(dt.datetime.now()))
    time_list.append(dt.datetime.time(dt.datetime.now()))
    t = TreeModel(decision_times=[0, 15, 45, 85, 185, 285, 385])
    print('End tree',dt.datetime.time(dt.datetime.now()))
    time_list.append(dt.datetime.time(dt.datetime.now()))
    bau_default_model = DLWBusinessAsUsual()
    bau_default_model.bau_emissions_setup(tree=t)
    print('End bau',dt.datetime.time(dt.datetime.now()))
    time_list.append(dt.datetime.time(dt.datetime.now()))
    c = DLWCost(t, bau_default_model.emit_level[0], g=92.08, a=3.413, join_price=2000.0, max_price=2500.0,
					tech_const=1.5, tech_scale=0.0, cons_at_0=30460.0)
    print('End cost',dt.datetime.time(dt.datetime.now()))
    time_list.append(dt.datetime.time(dt.datetime.now()))
    df = DLWDamage(tree=t, bau=bau_default_model, cons_growth=0.015, ghg_levels=[450, 650, 1000], subinterval_len=5)    
    df.damage_simulation( draws=4000000, peak_temp=6.0, disaster_tail=18.0, tip_on=True, 
							 temp_map=0, temp_dist_params=None, maxh=100.0)
    print('End damage',dt.datetime.time(dt.datetime.now()))
    time_list.append(dt.datetime.time(dt.datetime.now()))
    u = EZUtility(tree=t, damage=df, cost=c, period_len=5.0, eis=0.9, ra=7.0, time_pref=0.005)
    print('End utility',dt.datetime.time(dt.datetime.now()))
    time_list.append(dt.datetime.time(dt.datetime.now()))
    ga_model = GeneticAlgorithm(pop_amount=150, num_generations=75, cx_prob=0.8, mut_prob=0.5, 
	                            bound=1.5, num_feature=63, utility=u, print_progress=True) 
    gs_model = GradientSearch(var_nums=63, utility=u, accuracy=1e-8, 
	                          iterations=200, print_progress=True)
    final_pop, fitness = ga_model.run()
    sort_pop = final_pop[np.argsort(fitness)][::-1]
    m_opt, u_opt = gs_model.run(initial_point_list=sort_pop, topk=1)

    print("SCC: ", c.price(0, m_opt[0], 0))
    print('End opt/End',dt.datetime.time(dt.datetime.now()))
    time_list.append(dt.datetime.time(dt.datetime.now()))
    result_time_list =[0]
    #change dt.time to dt.timedelta so that it can be added or minused
    temp_list =list()
    for x in time_list:
        temp_list.append( dt.timedelta(hours=x.hour, minutes=x.minute, seconds=x.second, microseconds=x.microsecond))
    for i in range(len(temp_list)-1):
        i+=1
        result_time_list.append((temp_list[i]-temp_list[i-1]).total_seconds())
    price_list = list()
    for decision_time in range(len(t.decision_times)-1):
    	start_node,end_node = t.get_nodes_in_period(decision_time)
    	average_mit = df.average_mitigation(m_opt,decision_time)
    	for index in range(end_node-start_node+1):
    		index_ori =index + start_node
    		price_list.append(c.price(t.decision_times[decision_time],m_opt[index_ori],average_mit[index]))
    return result_time_list, m_opt,u_opt,price_list
if __name__ == "__main__":
    count =0 
    result_list = list()
    while count <1:
        x = base_case()
        result_list.append(x)
        count +=1
    with open('sensitive_analysis_base_renewal.pkl','wb') as f:
        pickle.dump(result_list,f)
#    with open('sensitive_analysis_100.pkl','rb') as inputs:
#        re = pickle.load(inputs)
#    print(re)