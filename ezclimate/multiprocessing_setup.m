%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%           Yili Yang, July 2017
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% set up the multipocessing package in python for MATLAB

%Use the function 'py.multiprocessing.forking.set_executable' to change the executable used by the multiprocessing module. 
[v, exe] = pyversion; 
py.multiprocessing.forking.set_executable(exe)
%Create an attribute 'argv' on the 'sys' module which is a Python list containing an empty string. 
sys = py.eval('__import__(''sys'')', struct);
py.setattr(sys,'argv', {py.str});
%Need to bring the Python module object into MATLAB and get the function object. 
mod = py.eval('__import__(''multiprocessing'')',struct);
