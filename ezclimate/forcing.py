from __future__ import division
import numpy as np


class Forcing(object):
	"""Radiative forcing for the EZ-Climate model. Determines the excess energy created 
	by GHGs in the atmosphere. 

	Attributes
	----------
	sink_start : float
		sinking constant
	forcing_start : float
		forcing start constant
	forcing_p1 : float
		forcing constant
	forcing_p2 : float
		forcing constant 
	forcing_p3 : float
		forcing constant
	absorption_p1 : float
		absorption constant
	absorption_p2 : float
		absorption constant
	lsc_p1 : float
		class constant
	lsc_p2 : float
		class constant 

	"""
	# parameters that I have no idea about 
	sink_start = 35.596
	forcing_start = 4.926
	forcing_p1 = 0.13173
	forcing_p2 = 0.607773
	forcing_p3 = 315.3785
	absorption_p1 = 0.94835
	absorption_p2 = 0.741547
	lsc_p1 = 285.6268
	lsc_p2 = 0.88414

	@classmethod
	def forcing_and_ghg_at_node(cls, m, node, tree, bau, subinterval_len, returning="forcing"):
		"""Calculates the radiative forcing based on GHG evolution leading up to the 
		damage calculation in `node`.

		Parameters
		----------
		m : ndarray
			array of mitigations
		node : int
			node for which forcing is to be calculated
		tree : `TreeModel` object 
			tree structure used
		bau : `BusinessAsUsual` object
			business-as-usual scenario of emissions
		subinterval_len : float
			subinterval length
		returning : string, optional
			* "forcing": implies only the forcing is returned
			* "ghg": implies only the GHG level is returned
			* "both": implies both the forcing and GHG level is returned

        Returns
        -------
        tuple or float
        	if `returning` is 
        		* "forcing": only the forcing is returned
        		* "ghg": only the GHG level is returned
        		* "both": both the forcing and GHG level is returned 

		"""
		#for the start state, return 0 for forcing and ghg_start for the ghg_level
		#call bau to get the ghg level
		if node == 0:
			if returning == "forcing":
				return 0.0
			elif returning== "ghg":
				return bau.ghg_start
			else:
				return 0.0, bau.ghg_start
		# get the period and the path that the target node are in 
		period = tree.get_period(node)
		path = tree.get_path(node, period) 
		# the decision time is the time when we make a mitigation, i.e. an array like [15,30,45,70]
		period_lengths = tree.decision_times[1:period+1] - tree.decision_times[:period]
		#increments are the numbers of subintervals within a period
		increments = period_lengths/subinterval_len

		#assign beginning values
		cum_sink = cls.sink_start
		cum_forcing = cls.forcing_start
		ghg_level = bau.ghg_start

		for p in range(0, period):
			#for each period, we calculate the start_emission and end_emission from bau.emission_by_decisions
			#! problem: when will the act takes in to effect? either way, code here should be wrong.
			#emission_by_decision: the emission level at a decision point
			start_emission = (1.0 - m[path[p]]) * bau.emission_by_decisions[p] # this is a attr of func: emission_by_step, might needed recode this
			if p < tree.num_periods-1: #if not too late to implement mitigation
				end_emission = (1.0 - m[path[p]]) * bau.emission_by_decisions[p+1] #if not the final states, the end emission is 
			else:
				end_emission = start_emission #emission level remains constant since the second to last period
			increment = int(increments[p])#number of subintervals in period p

			# for each increment in a period, the forcing is affecting ghg_level in the end
			for i in range(0, increment):
				#allocate the emission level change across time
				p_co2_emission = start_emission + i * (end_emission-start_emission) / increment
				p_co2 = 0.71 * p_co2_emission #level of p_co2
				p_c = p_co2 / 3.67  #level of p_c
				add_p_ppm = subinterval_len * p_c / 2.13
				lsc = cls.lsc_p1 + cls.lsc_p2 * cum_sink #benchmark
				absorption = 0.5 * cls.absorption_p1 * np.sign(ghg_level-lsc) * np.abs(ghg_level-lsc)**cls.absorption_p2
				cum_sink += absorption
				cum_forcing += cls.forcing_p1*np.sign(ghg_level-cls.forcing_p3)*np.abs(ghg_level-cls.forcing_p3)**cls.forcing_p2
				ghg_level += add_p_ppm - absorption

		if returning == "forcing":
			return cum_forcing
		elif returning == "ghg":
			return ghg_level
		else:
			return cum_forcing, ghg_level
	
	@classmethod
	def forcing_at_node(cls, m, node, tree, bau, subinterval_len):
		"""Calculates the forcing based mitigation leading up to the 
		damage calculation in `node`.

		Parameters
		----------
		m : ndarray 
			array of mitigations in each node. 
		node : int 
			the node for which the forcing is being calculated.

		Returns
		-------
		float 
			forcing 

		"""

		return cls.forcing_and_ghg_at_node(m, node, tree, bau, subinterval_len, returning="forcing")

	@classmethod
	def ghg_level_at_node(cls, m, node, tree, bau, subinterval_len):
		"""Calculates the GHG level leading up to the damage calculation in `node`.

		Parameters
		----------
		m : ndarray 
			array of mitigations in each node. 
		node : int 
			the node for which the GHG level is being calculated.

		Returns
		-------
		float 
			GHG level at node

		"""
		return cls.forcing_and_ghg_at_node(m, node,tree, bau, subinterval_len, returning="ghg")
		
