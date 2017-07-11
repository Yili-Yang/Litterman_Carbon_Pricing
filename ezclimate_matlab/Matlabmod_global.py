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


    def utility(self,m):
        m = np.array(m)
        result_array=np.array([])
        row,col = m.shape()
        for row_index in range(row):
            np.append(result_array,u.utility(m[row_index,:])
        return result_array

def get_u(m,y):
    return y.utility(m)

