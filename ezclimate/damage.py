from __future__ import division, print_function
import numpy as np
from abc import ABCMeta, abstractmethod
from damage_simulation import DamageSimulation
from forcing import Forcing

class Damage(object):
	"""Abstract damage class for the EZ-Climate model.

	Parameters
	----------
	tree : `TreeModel` object
		provides the tree structure used
	bau : `BusinessAsUsual` object
		business-as-usual scenario of emissions

	Attributes
	----------
	tree : `TreeModel` object
		provides the tree structure used
	bau : `BusinessAsUsual` object
		business-as-usual scenario of emissions

	"""
	__metaclass__ = ABCMeta
	def __init__(self, tree, bau):
		self.tree = tree
		self.bau = bau

	@abstractmethod
	def average_mitigation(self):
		"""The average_mitigation function should return a 1D array of the
		average mitigation for every node in the period.
		"""
		pass

	@abstractmethod
	def damage_function(self):
		"""The damage_function should return a 1D array of the damages for
		every node in the period.
		"""
		pass

class DLWDamage(Damage):
	"""Damage class for the EZ-Climate model. Provides the damages from emissions and mitigation outcomes.

	Parameters
	----------
	tree : `TreeModel` object
		provides the tree structure used
	bau : `BusinessAsUsual` object
		business-as-usual scenario of emissions
	cons_growth : float
		constant consumption growth rate
	ghg_levels : ndarray or list
		end GHG levels for each end scenario
	subinterval_len: float
	 	represents the length of a typical sub-interval.

	Attributes
	----------
	tree : `TreeModel` object
		provides the tree structure used
	bau : `BusinessAsUsual` object
		business-as-usual scenario of emissions
	cons_growth : float
		constant consumption growth rate
	ghg_levels : ndarray or list
		end GHG levels for each end scenario
	dnum : int 
		number of simulated damage scenarios
	d : ndarray
		simulated damages
	d_rcomb : ndarray
		adjusted simulated damages for recombining tree
	cum_forcing : ndarray
		cumulative forcing interpolation coefficients, used to calculate forcing based mitigation
	forcing : `Forcing` object
		class for calculating cumulative forcing and GHG levels
	damage_coefs : ndarray
		interpolation coefficients used to calculate damages

	emit_pct: float? shouldn't it be an array?
		= 1.0 - (self.ghg_levels-self.bau.ghg_start) / bau_emission

	cum_forcings :???

	"""

	def __init__(self, tree, bau, cons_growth, ghg_levels, subinterval_len):
		super(DLWDamage, self).__init__(tree, bau)
		self.ghg_levels = ghg_levels
		if isinstance(self.ghg_levels, list):
			self.ghg_levels = np.array(self.ghg_levels)
		self.cons_growth = cons_growth
		self.dnum = len(ghg_levels)
		self.subinterval_len = subinterval_len
		self.cum_forcings = None
		self.d = None
		self.d_rcomb = None
		self.emit_pct = None
		self.damage_coefs = None

	def _recombine_nodes(self):
		"""Creating damage coefficients for recombining tree. The state reached by an up-down move is
		separate from a down-up move because in general the two paths will lead to different degrees of 
		mitigation and therefore of GHG level. A 'recombining' tree is one in which the movement from 
		one state to the next through time is nonetheless such that an up move followed by a down move 
		leads to the same fragility. 
		"""
		nperiods = self.tree.num_periods
		sum_class = np.zeros(nperiods, dtype=int)
		new_state = np.zeros([nperiods, self.tree.num_final_states], dtype=int)
		temp_prob = self.tree.final_states_prob.copy()
		self.d_rcomb = self.d.copy()

		for old_state in range(self.tree.num_final_states): #look at final states
			temp = old_state
			n = nperiods-2
			d_class = 0
			while n >= 0:
				if temp >= 2**n:
					temp -= 2**n
					d_class += 1
				n -= 1
			sum_class[d_class] += 1
			new_state[d_class, sum_class[d_class]-1] = old_state # slicing the np array with the right length and merge the old states in to a new one (states given period is the order of a situation.)
		'''
		the new_state for our model should be something like
		 0
		 1  2  4  8  16
		 3  5  6  9  10 12 17 18 20 24
		 7 11  13  14 19 21 22 25 26 28
		 15 23 27 29 30
		 31
		the sum_class should be [1 5 10 10 5 1]
		'''
		sum_nodes = np.append(0, sum_class.cumsum())
		prob_sum = np.array([self.tree.final_states_prob[sum_nodes[i]:sum_nodes[i+1]].sum() for i in range(len(sum_nodes)-1)])

		'''
		sum_nodes: [ 0, 1, 6, 16, 26, 31, 32]
		prob_sum: sums up the probabilities of final states partitioned by sum_nodes
		'''

		for period in range(nperiods): #look into each period
			for k in range(self.dnum): #look into each simulated scenario
				d_sum = np.zeros(nperiods)  #store the probability-weighted sum of the simulated damage for each category
				old_state = 0 #direct to the first node in the the category set, signal
				for d_class in range(nperiods): #look into each category
					d_sum[d_class] = (self.tree.final_states_prob[old_state:old_state+sum_class[d_class]] \
						 			 * self.d_rcomb[k, old_state:old_state+sum_class[d_class], period]).sum()

					old_state += sum_class[d_class] # moving to the next category set
					self.tree.final_states_prob[new_state[d_class, 0:sum_class[d_class]]] = temp_prob[0] #same probability for the final states

				for d_class in range(nperiods):
					self.d_rcomb[k, new_state[d_class, 0:sum_class[d_class]], period] = d_sum[d_class] / prob_sum[d_class]
                    # find the probability-weighted average damage

		self.tree.node_prob[-len(self.tree.final_states_prob):] = self.tree.final_states_prob
   		#update the prob corresponding to the final nodes
		for p in range(1,nperiods-1): #look into intermediate periods
			nodes = self.tree.get_nodes_in_period(p) #the first and last node for the period
			for node in range(nodes[0], nodes[1]+1): #look into all the nodes for the period
				worst_end_state, best_end_state = self.tree.reachable_end_states(node, period=p) #determine reachable final states
				self.tree.node_prob[node] = self.tree.final_states_prob[worst_end_state:best_end_state+1].sum()
            #update the nodes's prob using the new final_states_prob (always end with storing in the nodes)

	def _damage_interpolation(self):
		"""Create the interpolation coefficients used in `damage_function`."""
		if self.d is None:
			print("Importing stored damage simulation")
			self.import_damages()

		self._recombine_nodes()
        #init emit_pct
		if self.emit_pct is None:
			bau_emission = self.bau.ghg_end - self.bau.ghg_start
			self.emit_pct = 1.0 - (self.ghg_levels-self.bau.ghg_start) / bau_emission
		
		self.damage_coefs = np.zeros((self.tree.num_final_states, self.tree.num_periods, self.dnum-1, self.dnum))
		amat = np.ones((self.tree.num_periods, self.dnum, self.dnum))
		bmat = np.ones((self.tree.num_periods, self.dnum))

		self.damage_coefs[:, :, -1,  -1] = self.d_rcomb[-1, :, :] # d_romb's index is [path_index,the numbers in the class, period]
		self.damage_coefs[:, :, -1,  -2] = (self.d_rcomb[-2, :, :] - self.d_rcomb[-1, :, :]) / self.emit_pct[-2]
        #difference in simulation outcomes/cumulative emission

		amat[:, 0, 0] = 2.0 * self.emit_pct[-2]
		amat[:, 1:, 0] = self.emit_pct[:-1]**2
		amat[:, 1:, 1] = self.emit_pct[:-1]
		amat[:, 0, -1] = 0.0

		for state in range(0, self.tree.num_final_states):
			bmat[:, 0] = self.damage_coefs[state, :, -1,  -2] * self.emit_pct[-2]
			bmat[:, 1:] = self.d_rcomb[:-1, state, :].T #?
			self.damage_coefs[state, :, 0] = np.linalg.solve(amat, bmat)

	def import_damages(self, file_name="simulated_damages"): #documented
		"""Import saved simulated damages. File must be saved in 'data' directory
		inside current working directory. Save imported values in `d`. 

		Parameters
		----------
		file_name : str, optional
			name of file of saved simulated damages

		Raises
		------
		IOError
			If file does not exist.

		"""
		from tools import import_csv # import damage from a csv file
		try:
			d = import_csv(file_name, ignore="#", header=False)
		except IOError as e:
			import sys
			print("Could not import simulated damages:\n\t{}".format(e))
			sys.exit(0)

		n = self.tree.num_final_states	
		self.d = np.array([d[n*i:n*(i+1)] for i in range(0, self.dnum)])
        #d is an array with entries being the simulated outcomes for damages in the final states.
		self._damage_interpolation()

	def damage_simulation(self, draws, peak_temp=9.0, disaster_tail=12.0, tip_on=True, 
		temp_map=1, temp_dist_params=None, maxh=100.0, save_simulation=True): #documented
		"""Initialization and simulation of damages, given by :mod:`ez_climate.DamageSimulation`.

		Parameters
		----------
		draws : int
			number of Monte Carlo draws
		peak_temp : float, optional 
			tipping point parameter 
		disaster_tail : float, optional
			curvature of tipping point
		tip_on : bool, optional
			flag that turns tipping points on or off
		temp_map : int, optional
			mapping from GHG to temperature
		        * 0: implies Pindyck displace gamma
		        * 1: implies Wagner-Weitzman normal
		        * 2: implies Roe-Baker
		        * 3: implies user-defined normal 
		        * 4: implies user-defined gamma
		temp_dist_params : ndarray or list, optional
			if temp_map is either 3 or 4, user needs to define the distribution parameters
		maxh : float, optional
			time parameter from Pindyck which indicates the time it takes for temp to get half
		        way to its max value for a given level of ghg
		cons_growth : float, optional 
			yearly growth in consumption
		save_simulation : bool, optional
			True if simulated values should be save, False otherwise

		Returns
		-------
		ndarray
			simulated damages

		"""
		# get simulated damage from damage-simulation.py
		ds = DamageSimulation(tree=self.tree, ghg_levels=self.ghg_levels, peak_temp=peak_temp,
					disaster_tail=disaster_tail, tip_on=tip_on, temp_map=temp_map, 
					temp_dist_params=temp_dist_params, maxh=maxh, cons_growth=self.cons_growth)
		print("Starting damage simulation..")
		self.d = ds.simulate(draws, write_to_file = False)
		print("Done!")
		self._damage_interpolation()
		return self.d

	def _forcing_init(self):
		"""Initialize `Forcing` object and cum_forcings used in calculating the force mitigation up to a node.""" 
		if self.emit_pct is None:
			bau_emission = self.bau.ghg_end - self.bau.ghg_start
			self.emit_pct = 1.0 - (self.ghg_levels-self.bau.ghg_start) / bau_emission

		self.cum_forcings = np.zeros((self.tree.num_periods, self.dnum)) # array like [x,y] contains number of the periods and the path
		mitigation = np.ones((self.dnum, self.tree.num_decision_nodes)) * self.emit_pct[:, np.newaxis]
        #mitigaion is indexed with number of path (row) and number of nodes(column), and is the emit_pct

		for i in range(0, self.dnum): #look into each simulation
			for n in range(1, self.tree.num_periods+1):
				node = self.tree.get_node(n, 0) #the node of state 0 in period n
				self.cum_forcings[n-1, i] = Forcing.forcing_at_node(mitigation[i], node, self.tree,
																	self.bau, self.subinterval_len) # return the forcing on the node


	def _forcing_based_mitigation(self, forcing, period): 
		"""Calculation of mitigation based on forcing up to period. Interpolating between the forcing associated 
		with the constant degree of mitigation consistent with the damage simulation scenarios.
		"""
		# this whole function is based on a new theory
		p = period - 1
		if forcing > self.cum_forcings[p][1]:
			weight_on_sim2 = (self.cum_forcings[p][2] - forcing) / (self.cum_forcings[p][2] - self.cum_forcings[p][1])
			weight_on_sim3 = 0
		elif forcing > self.cum_forcings[p][0]:
			weight_on_sim2 = (forcing - self.cum_forcings[p][0]) / (self.cum_forcings[p][1] - self.cum_forcings[p][0])
			weight_on_sim3 = (self.cum_forcings[p][1] - forcing) / (self.cum_forcings[p][1] - self.cum_forcings[p][0])
		else:
			weight_on_sim2 = 0
			weight_on_sim3 = 1.0 + (self.cum_forcings[p][0] - forcing) / self.cum_forcings[p][0]
		
		return weight_on_sim2 * self.emit_pct[1] + weight_on_sim3*self.emit_pct[0]


	def average_mitigation_node(self, m, node, period=None): #documented
		"""Calculate the average mitigation up to a given node.

		Parameters
		----------
		m : ndarray or list
			array of mitigation
		node : int
			node for which average mitigation is to be calculated for
		period : int, optional
			the period the node is in
	
		Returns
		-------
		float
			average mitigation

		"""
		if period == 0:
			return 0
		if period is None:
			period = self.tree.get_period(node)
		state = self.tree.get_state(node, period)
		path = self.tree.get_path(node, period)
		new_m = m[path[:-1]] # mitigation on the path until this node
	
		period_len = self.tree.decision_times[1:period+1] - self.tree.decision_times[:period]
		bau_emissions = self.bau.emission_by_decisions[:period] #emission levels at each decision point
		total_emission = np.dot(bau_emissions, period_len) #total emission: sum of emissions during each period
		ave_mitigation = np.dot(new_m, bau_emissions*period_len) # mitigation for a path until node
		return ave_mitigation / total_emission # average mitigation until node

	def average_mitigation(self, m, period): #documented
		"""Calculate the average mitigation for all nodes in a period.

		m : ndarray or list
			array of mitigation
		period : int
			period to calculate average mitigation for
		
		Returns
		-------
		ndarray
			average mitigations 

		"""
		nodes = self.tree.get_num_nodes_period(period) #number of nodes for a given period
		ave_mitigation = np.zeros(nodes)
		for i in range(nodes):
			node = self.tree.get_node(period, i)
			ave_mitigation[i] = self.average_mitigation_node(m, node, period)
		return ave_mitigation

	def _ghg_level_node(self, m, node): #documented
		return Forcing.ghg_level_at_node(m, node, self.tree, self.bau, self.subinterval_len)

	def ghg_level_period(self, m, period=None, nodes=None): #documented
		"""Calculate the GHG levels corresponding to the given mitigation.
		Need to provide either `period` or `nodes`.

		Parameters
		----------
		m : ndarray or list
			array of mitigation
		period : int, optional
			what period to calculate GHG levels for
		nodes : ndarray or list, optional
			the nodes to calculate GHG levels for
		
		Returns
		-------
		ndarray
			GHG levels

		"""
		if nodes is None and period is not None:
			start_node, end_node = self.tree.get_nodes_in_period(period)
			if period >= self.tree.num_periods:
				add = end_node-start_node+1
				start_node += add
				end_node += add
			nodes = np.array(range(start_node, end_node+1))
		if period is None and nodes is None:
			raise ValueError("Need to give function either nodes or the period")

		ghg_level = np.zeros(len(nodes))
		for i in range(len(nodes)):
			ghg_level[i] = self._ghg_level_node(m, nodes[i])
		return ghg_level

	def ghg_level(self, m, periods=None): #documented
		"""Calculate the GHG levels for more than one period.

		Parameters
		----------
		m : ndarray or list
			array of mitigation
		periods : int, optional
			number of periods to calculate GHG levels for
		
		Returns
		-------
		ndarray
			GHG levels 

		"""
		#create storage space for ghg_level for every possible states
		if periods is None:
			periods = self.tree.num_periods-1
		if periods >= self.tree.num_periods:
			ghg_level = np.zeros(self.tree.num_decision_nodes+self.tree.num_final_states)
		else:
			ghg_level = np.zeros(self.tree.num_decision_nodes)
		# for each period, find the right start and end node within this period and add ghg_level for this nodes
		for period in range(periods+1):
			start_node, end_node = self.tree.get_nodes_in_period(period)
			if period >= self.tree.num_periods:
				add = end_node-start_node+1
				start_node += add
				end_node += add
			nodes = np.array(range(start_node, end_node+1))
			ghg_level[nodes] = self.ghg_level_period(m, nodes=nodes)
		return ghg_level

	def _damage_function_node(self, m, node):
		"""Calculate the damage at any given node, based on mitigation actions in `m`."""
		if self.damage_coefs is None:
			self._damage_interpolation()
		if self.cum_forcings is None:
			self._forcing_init()
		if node == 0:
			return 0.0

		period = self.tree.get_period(node)
		forcing, ghg_level = Forcing.forcing_and_ghg_at_node(m, node, self.tree, self.bau, self.subinterval_len, "both")
		force_mitigation = self._forcing_based_mitigation(forcing, period)
		ghg_extension = 1.0 / (1 + np.exp(0.05*(ghg_level-200)))

		worst_end_state, best_end_state = self.tree.reachable_end_states(node, period=period)
		probs = self.tree.final_states_prob[worst_end_state:best_end_state+1]
		# new damage formulas 
		if force_mitigation < self.emit_pct[1]:
			damage = (probs *(self.damage_coefs[worst_end_state:best_end_state+1, period-1, 1, 1] * force_mitigation \
					 + self.damage_coefs[worst_end_state:best_end_state+1, period-1, 1, 2])).sum()
		
		elif force_mitigation < self.emit_pct[0]:
			damage = (probs * (self.damage_coefs[worst_end_state:best_end_state+1, period-1, 0, 0] * force_mitigation**2 \
					  + self.damage_coefs[worst_end_state:best_end_state+1, period-1, 0, 1] * force_mitigation \
					  + self.damage_coefs[worst_end_state:best_end_state+1, period-1, 0, 2])).sum()
		else: 
			damage = 0.0
			i = 0
			for state in range(worst_end_state, best_end_state+1): 
				if self.d_rcomb[0, state, period-1] > 1e-5:
					deriv = 2.0 * self.damage_coefs[state, period-1, 0, 0]*self.emit_pct[0] \
							+ self.damage_coefs[state, period-1, 0, 1]
					decay_scale = deriv / (self.d_rcomb[0, state, period-1]*np.log(0.5))
					dist = force_mitigation - self.emit_pct[0] + np.log(self.d_rcomb[0, state, period-1]) \
						   / (np.log(0.5) * decay_scale) 
					damage += probs[i] * (0.5**(decay_scale*dist) * np.exp(-np.square(force_mitigation-self.emit_pct[0])/60.0))
				i += 1

		return (damage / probs.sum()) + ghg_extension

	def damage_function(self, m, period):
		"""Calculate the damage for every node in a period, based on mitigation actions `m`.

		Parameters
		----------
		m : ndarray or list
			array of mitigation
		period : int
			period to calculate damages for
		
		Returns
		-------
		ndarray
			damages

		"""
		nodes = self.tree.get_num_nodes_period(period)
		damages = np.zeros(nodes)
		for i in range(nodes):
			node = self.tree.get_node(period, i)
			damages[i] = self._damage_function_node(m, node)
		return damages 


