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
        ga_model = GeneticAlgorithm(pop_amount=150, num_generations=70, cx_prob=0.8, mut_prob=0.5, 
                              bound=1.5, num_feature=63, utility=self.u, print_progress=True) 
        final_pop, fitness = ga_model.run()
        sort_pop = final_pop[np.argsort(fitness)][-1]
        return sort_pop

    def utility_grad(self,m):
        m = np.array(m)
        gs_model = GradientSearch(var_nums=63, utility=self.u, accuracy=1e-8, 
                              iterations=1, print_progress=True)
        grad = gs_model.numerical_gradient(m)
        return self.u.utility(m),grad

def get_start(y):
    return y.get_start_point()

def get_u_g(m,y):
    return y.utility_grad(m)

