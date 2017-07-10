% ADMIT (Automatic Differentiation and Matlab Interface Toolbox)
% Version 1.0, 1-Feb-1997
%       
% Sparse Jacobian/Hessian 
%		
%	evalJ 			- Evaluate sparse Jacobian
%	evalH 			- Evaluate sparse Hessian
%	GetJPI	 		- Compute Sparsity+Coloring Info.(for Jacobians)
%	GetHPI			- Compute Sparsity+Coloring Info.(for Hessians)
%	dispJPI		 	- Display Sparsity+Coloring Info.(for Jacobians)
%	dispHPI			- Display Sparsity+Coloring Info.(for Hessians)
%
% Computing the Function
%
%	funcval			- Compute the scalar nonlinear function
%	funcvalJ		- Compute the vector nonlinear function
%
% AD Drivers
%
%	forwprod		- Compute J*V at a given point.
%	revprod			- Compute J'*V at a given point.
%	HtimesV			- Compute H*V (for scalar functions)
%	VHtimesV		- Compute V^T*H*V (for scalar functions)
%	WHtimesV		- Compute W^T*H*V (for scalar functions)
%	HVapp			- Compute H*V using Finite Diff on gradient computed by AD
%	HessSP			- Compute sparsity pattern of Hessian
%	JacSP			- Compute sparsity pattern of Jacobian
%
% Finite Difference drivers
%
%	FDapprox		- Approximate J*V using Finite Diff.
%	FDHapp			- Approximate H*V using Finite Diff.
%	
% General
%		
%	cleanup			- cleanup the toolbox
%	startupADMIT		- startup ADMIT
