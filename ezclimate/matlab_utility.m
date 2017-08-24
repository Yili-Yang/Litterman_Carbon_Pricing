%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%           Yili Yang, Aug 2017
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Return the utility at the input mitigation level. 
%
% Input:
% m_in_mat: mitigation level stored in matlab double
% varargin: instance of matlabmode class in Matlabmod (Provide damage 
% simualtion and utility)
%
% Output:
% re - utlity at the input mitigation level.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function re_array = matlab_utility(m_in_mat,varargin)

m_in_mat = m_in_mat';
pytu = py.Matlabmod.get_u(m_in_mat,varargin{:});
re_array = -double(py.array.array('d',py.numpy.nditer(pytu)));
%g = -double(py.array.array('d',py.numpy.nditer(pytu(2))));
end
