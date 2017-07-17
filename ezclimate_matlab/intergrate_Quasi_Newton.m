%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%           Yili Yang, July 2017
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Using Genetic Algorithm to find the start point and then us Quasi-Newton
% method as the local optimizer to get the optimal mitigation level on each
% node
% Output:
% f - final function value
% x - final point where we stop
% fcount - number of evaluation of function value
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


varargin = py.Matlabmod.matlabmode();  % init the class in Matlabmode_g
m_0 = py.Matlabmod.get_start(varargin);% call GA in matlabmode_g to get a start point for the local optimizer
m_in_mat_0 = double(py.array.array('d',py.numpy.nditer(m_0)))'; % change the numpy array mitigation level to double in matlab
fun = @matlab_utility_g;
[fmin2,xmin2,fcount2] = Quasi_Newton(fun,m_in_mat_0,varargin);% run Quasi_Newton loacl optimizer