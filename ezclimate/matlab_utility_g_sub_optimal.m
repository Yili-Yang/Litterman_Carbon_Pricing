%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%           Yili Yang, Aug 2017
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Return the utility and using finite differeciation to get the gradient of
% the utiltity function at the input mitigation level. 
%
% Input:
% m_in_mat: mitigation level stored in matlab double
% varargin: instance of matlabmode class in Matlabmod (Provide damage 
% simualtion and utility)
%
% Output:
% re - objective function value: 
%     1. utility + positive modification term if utility is calculated by python
%     2. positive modification term if utility is not calculate by python 
% g - gradient of the utility 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [re,g] = matlab_utility_g_sub_optimal(m_in_mat,varargin)
gamma =1e10;
epi = 1e-10;
m_in_mat = m_in_mat';
pytuple = py.Matlabmod.utility_sub_opt(m_in_mat,varargin{:});
re_array = -double(py.array.array('d',pytuple(1)));
positive_add_up = 0;
m_size = size(m_in_mat);
for col = 1:m_size(2)
    positive_add_up = positive_add_up + gamma*(min(m_in_mat(1,col)-epi,0))^2;
end
if isnan(re_array) >0
    re = positive_add_up;
else
    re = re_array + positive_add_up;
end
disp(re)
g = -double(py.array.array('d',py.numpy.nditer(pytuple(2))))';
disp(norm(g))
end