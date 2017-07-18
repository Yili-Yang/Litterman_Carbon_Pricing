# -- coding utf-8 --

#Created on Fri Jun 16 151644 2017
#@author Ted Yang


import datetime as dt
from tree import TreeModel
from bau import DLWBusinessAsUsual
from cost import DLWCost
from damage import DLWDamage
from utility import EZUtility
from optimization import GeneticAlgorithm, GradientSearch
import numpy as np
class matlabmode():
    def __init__(self):
        '''init the class with default settings:
        1. decision time is set to [0, 15, 45, 85, 185, 285, 385]
        2. cost is using default x60 = 0.543, x100 = 0.671 and euro to dollar exchange rate = 1.2
        3. In the back stop tech model, join price is set to 2000, max prive is set to 2500, phi_0 = 1.5, phi_1 = 0 and constant = 30460
        3. constant growth of consumption is set to 0.015, subinterval length is 5 and ghg levels are 450,650,1000.
        4. Draws of simulation  = 4000000
        5. Disaster model's set up is  peak_temperature=6.0, disaster_tail=18.0. 
        6. Damage is simulated by pindcyk method with time to hit the max temperature = 100
        7. In utility, the parameter rho from the DLW-paper is set to 1-1/0.9, alpha is set to -6 and beta is set to 0.995^5 '''

        t = TreeModel(decision_times=[0, 15, 45, 85, 185, 285, 385])
        bau_default_model = DLWBusinessAsUsual()
        bau_default_model.bau_emissions_setup(tree=t)
        c = DLWCost(t, bau_default_model.emit_level[0], g=92.08, a=3.413, join_price=2000.0, max_price=2500.0,
                        tech_const=1.5, tech_scale=0.0, cons_at_0=30460.0)
        df = DLWDamage(tree=t, bau=bau_default_model, cons_growth=0.015, ghg_levels=[450, 650, 1000], subinterval_len=5)    
        df.damage_simulation(draws=4000000, peak_temp=6.0, disaster_tail=18.0, tip_on=True, 
                                 temp_map=0, temp_dist_params=None, maxh=100.0)
        u = EZUtility(tree=t, damage=df, cost=c, period_len=5.0, eis=0.9, ra=7.0, time_pref=0.005)
        self.u = u

    def get_start_point(self):
        #use GA to get the start point for local optimizer
        ga_model = GeneticAlgorithm(pop_amount=150, num_generations=75, cx_prob=0.8, mut_prob=0.5, 
                              bound=1.5, num_feature=63, utility=self.u, print_progress=True) 
        final_pop, fitness = ga_model.run()
        sort_pop = final_pop[np.argsort(fitness)][-1]
        return sort_pop

    def utility_grad(self,m):
        #use finite differenciation to gradient and utility
        m = np.array(m)
        gs_model = GradientSearch(var_nums=63, utility=self.u, accuracy=1e-8, 
                              iterations=1, print_progress=True)
        grad = gs_model.numerical_gradient(m)
        return self.u.utility(m),grad

    def grad(self,m):
        #use finite differenciation to gradient and utility
        m = np.array(m)
        gs_model = GradientSearch(var_nums=63, utility=self.u, accuracy=1e-8, 
                              iterations=1, print_progress=True)
        grad = gs_model.numerical_gradient(m)
        return grad

    def utility(self,m):
        # get utility from utlity class
        m = np.array(m)
        #result_array=np.array([])
        # if m.ndim ==1:
        return self.u.utility(m)
            
        # else:
        #     row= 10
        #     for row_index in range(row):
        #         result_array= np.append(result_array,self.u.utility(m[row_index,:]))
        #     return result_array
    def GS(self,m):
    	m = np.array(m)
        gs_model = GradientSearch(var_nums=63, utility=self.u, accuracy=1e-8, 
                              iterations=200, print_progress=True)
    	m_opt, u_opt = gs_model.run(initial_point_list=sort_pop, topk=1)
    	return m_opt,u_opt

def get_start(y):
    return y.get_start_point()

def get_u_g(m,y):
    return y.utility_grad(m)

def get_u(m,y):
    return y.utility(m)

def get_g(m,y):
    return y.grad(m)
    
def call_gs(m,y):
	return y.GS(m):