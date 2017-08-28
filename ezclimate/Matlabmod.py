from scipy.odr import Model, Data, ODR
import datetime as dt
from tree import TreeModel
from bau import DLWBusinessAsUsual
from cost import DLWCost
#from damage import DLWDamage
from utility import EZUtility
from optimization import GeneticAlgorithm, GradientSearch
import numpy as np
import multiprocessing as mp
from tools import _pickle_method, _unpickle_method
try:
    import copy_reg
except:
    import copyreg as copy_reg
import types

class matlabmode():
    def __init__(self,ind):
        '''init the class with default settings:
        1. decision time is set to [0, 15, 45, 85, 185, 285, 385]
        2. cost is using default x60 = 0.543, x100 = 0.671 and euro to dollar exchange rate = 1.2
        3. In the back stop tech model, join price is set to 2000, max prive is set to 2500, phi_0 = 1.5, phi_1 = 0 and constant = 30460
        3. constant growth of consumption is set to 0.015, subinterval length is 5 and ghg levels are 450,650,1000.
        4. Draws of simulation  = 4000000
        5. Disaster model's set up is  peak_temperature=6.0, disaster_tail=18.0. 
        6. Damage is simulated by pindcyk method with time to hit the max temperature = 100
        7. In utility, the parameter rho from the DLW-paper is set to 1-1/0.9, alpha is set to -6 and beta is set to 0.995^5 '''
        ind = int(ind)
        t = TreeModel(decision_times=[0, 15, 45, 85, 185, 285, 385])
        self.t = t 
        bau_default_model = DLWBusinessAsUsual()
        bau_default_model.bau_emissions_setup(tree=t)
        if ind == -1:
            from damage_fix_seed import DLWDamage
            c = DLWCost(t, bau_default_model.emit_level[0], g=92.08, a=3.413, join_price=2000.0, max_price=2500.0,
                            tech_const=1.5, tech_scale=0.0, cons_at_0=30460.0)
            df = DLWDamage(tree=t, bau=bau_default_model, cons_growth=0.015, ghg_levels=[450, 650, 1000], subinterval_len=5)    
            df.damage_simulation(draws=4000000, peak_temp=6.0, disaster_tail=18.0, tip_on=True, 
                                     temp_map=0, temp_dist_params=None, maxh=100.0)
            u = EZUtility(tree=t, damage=df, cost=c, period_len=5.0, eis=0.9, ra=7.0, time_pref=0.005)
            self.u = u
            paralist = np.array([[2.81, 4.6134, 6.14],[1.6667, 1.5974, 1.53139],[-0.25, -0.5, -1.0]])
        elif ind in [x for x in range(10)]:
            from damage_Yili import DLWDamage
            c = DLWCost(t, bau_default_model.emit_level[0], g=92.08, a=3.413, join_price=2000.0, max_price=2500.0,
                            tech_const=1.5, tech_scale=0.0, cons_at_0=30460.0)
            df = DLWDamage(tree=t, bau=bau_default_model, cons_growth=0.015, ghg_levels=[450, 650, 1000], subinterval_len=5,change=ind)    
            df.damage_simulation( draws=4000000, peak_temp=6.0, disaster_tail=18.0, tip_on=True, 
                                     temp_map=0, temp_dist_params=None, maxh=100.0)
            u = EZUtility(tree=t, damage=df, cost=c, period_len=5.0, eis=0.9, ra=7.0, time_pref=0.005)
            self.u = u
            paralist = np.array(self.u.damage.parameter_list)
        elif ind in (10,11):
            from damage import DLWDamage
            aa,bb,cost,g = self.sensitivity_analysis_c_k(ind)
            c = DLWCost(t, bau_default_model.emit_level[0], g=g, a=cost, join_price=2000.0, max_price=2500.0,
                    tech_const=1.5, tech_scale=0.0, cons_at_0=30460.0)
            df = DLWDamage(tree=t, bau=bau_default_model, cons_growth=0.015, ghg_levels=[450, 650, 1000], subinterval_len=5)    
            df.damage_simulation( draws=4000000, peak_temp=6.0, disaster_tail=18.0, tip_on=True, 
                                     temp_map=0, temp_dist_params=None, maxh=100.0)
            u = EZUtility(tree=t, damage=df, cost=c, period_len=5.0, eis=0.9, ra=7.0, time_pref=0.005)
            self.u = u
            paralist = np.array([aa,bb,cost,g])
        else:
            raise ValueError('Input indicator should be intergral within -1 to 11')
        self.parameters = paralist.ravel()
        #handle parameters:

    def sensitivity_analysis_c_k(self,ind):
        '''take fraction GHG reduction for different taxation rate from normal distribution
        returns the modified c and k in project description page 2 equation (2.3)'''
        #1.2 dollar = 1 euro
        xdata = [60*1.2,100*1.2]
        a = np.random.normal(0.543,0.0213)
        b = np.random.normal(0.671,0.0213)
        if ind == 0:
            ydata = [a,0.671]
        elif ind ==1:
            ydata = [0.543,b]
        else:
            ydata = [a,b]
        def f(p, x):
            '''Linear function y = m*x + b'''
            # B is a vector of the parameters.
            # x is an array of the current x values.
            # x is in the same format as the x passed to Data or RealData.
            #
            # Return an array in the same format as y passed to Data or RealData.
            return p[0] * x ** p[1]

        linear = Model(f)
        #sx, sy are arrays of error estimates
        mydata = Data(xdata, ydata)
        #beta0 are the initial parameter estimates
        myodr = ODR(mydata, linear, beta0=[1, -1.0])
        myoutput = myodr.run()
        x = myoutput.beta
        c= (1/x[1])*(x[1]+1) 
        g= ((1/(x[0]**(1/x[1])))**(x[1]+1) )*(x[0]-x[0]/(x[1]+1))
        return a,b,c,g

    def get_start_point(self):
        #use GA to get the start point for local optimizer
        ga_model = GeneticAlgorithm(pop_amount=150, num_generations=75, cx_prob=0.8, mut_prob=0.5, 
                              bound=1.5, num_feature=63, utility=self.u, print_progress=True) 
        final_pop, fitness = ga_model.run()
        sort_pop = final_pop[np.argsort(fitness)][::-1]
        begin_pop = final_pop[np.argsort(fitness)][-1]
        return sort_pop,begin_pop

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
        m = np.array(m)
        return self.u.utility(m)

    def GS(self,m):
        #m = np.array(m)
        m=m[0]
        gs_model = GradientSearch(var_nums=63, utility=self.u, accuracy=1e-8, 
                              iterations=200, print_progress=True)
        m_opt, u_opt = gs_model.run(initial_point_list=m, topk=1)
        return m_opt,u_opt

    def get_price(self,m):
        m = np.array(m)
        t = self.t
        price_list=list()
        for decision_time in range(len(t.decision_times)-1):
            start_node,end_node = t.get_nodes_in_period(decision_time)
            average_mit = self.u.damage.average_mitigation(m,decision_time)
            for index in range(end_node-start_node+1):
                index_ori =index + start_node
                price_list.append(self.u.cost.price(t.decision_times[decision_time],m[index_ori],average_mit[index]))
        return np.array(price_list)

    def utility_tree(self,m):
        # get utility in a tree structure from utlity class
        m = np.array(m)
        utility_tree = self.u.utility(m,True)[0]
        u_tree = utility_tree.tree
        utility_at_each_node = np.array([])
        for decision_time in self.t.decision_times[:-1]:
            utility_at_each_node = np.append(utility_at_each_node,u_tree[decision_time])

        return utility_at_each_node

    def utility_sub_optimal(self,m,adj,pos):
        # get utility from utlity class
        m = np.array(m)
        m = np.insert(m,[int(item) for item in pos],[adj])
        return self.u.utility(m), self.grad(m)

    def adj_utility_cons(self,m,cons):
        # get utility from utlity class
        m = np.array(m)

        return self.u.adjusted_utility(m,first_period_consadj=cons)

    def adj_utility_g(self,m, cons):
        m = np.array(m)
        gs_model = GradientSearch(var_nums=63, utility=self.u, accuracy=1e-8, 
                              iterations=1, print_progress=True)
        grad = gs_model.numerical_gradient_cons(m,cons)
        return grad

# following is the function to be called in matlab, they are written out side the class since the intergration doesn't support subscription in python class
def get_start(y):
    return y.get_start_point()

def get_u_g(m,y):
    return y.utility_grad(m)

def get_u(m,y):
    return y.utility(m)

def get_g(m,y):
    return y.grad(m)
    
def call_gs(m,y):
    return y.GS(m)

def get_parameters(y):
    return y.parameters

def get_price(m,y):
    return y.get_price(m)# -- coding utf-8 --

def get_utility_tree(m,y):
    return y.utility_tree(m)

def utility_sub_opt(m,adj,pos,y):
    return y.utility_sub_optimal(m,adj,pos)

def adj_utility_cons(cons,m,y):
    return y.adj_utility_cons(m,cons)

def adj_utility_cons_g(m,cons,y):
    return y.adj_utility_cons(m,cons),y.adj_utility_g(m,cons)