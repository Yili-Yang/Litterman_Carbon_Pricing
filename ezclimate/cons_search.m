function re_array = cons_search(z,opt_m,pyclass)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%           Yili Yang, July 2017
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Change the consumption on the first period and return the adjusted
% utility
% Inputs:
% z - adjusted percentage of the consumption on the first period
% opt_m - 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pyAdjUtility = py.Matlabmod.adj_utility_cons(z,opt_m,pyclass);
re_array = -double(py.array.array('d',pyAdjUtility));
end