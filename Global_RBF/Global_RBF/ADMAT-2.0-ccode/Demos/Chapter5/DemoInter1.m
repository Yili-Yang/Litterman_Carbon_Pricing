%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                1-D Interpolation in ADMAT
%
%                      
%                     July, 2008
%
%       Source code for Example 5.7.1 in Section 5.7 in User's Guide
%
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% initial values for interpolation 
x = 0:10; 
y = sin(x); 
% interpolation points
x0 = 0.2:0.2:1; 
% length of points
n = length(x0);
%
%  Call 'interp1_AD' for interpolation
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%        Linear interpolation method
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
display('Linear interpolation method.');
display('   1. linear interpolation by forward mode');
% comupte the interplated yi by forward mode
xi = deriv(x0, eye(n));
yi = interp1_AD(x,y,xi);
y0 = getval(yi)
J = getydot(yi)
% 
% compute the interplated yi by reverse mode
display('   2. linear interpolation by reverse mode');
xi = derivtape(x0,1);
yi = interp1_AD(x,y,xi);
y0 = getval(yi);
J = parsetape(eye(n));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%       Cubic spline interpolation method
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
display('Cubic spline interpolation method');
% cubic spline interpolation by forward mode
display('   1. Cubic spline by forward mode');
xi = deriv(x0, eye(n));
yi = interp1_AD(x,y,xi, 'spline');
y0 = getval(yi)
J = getydot(yi)

% cubic spline interpolation by reverse mode
display('   2. Cubic spline by reverse mode');
xi = derivtape(x0,1);
yi = interp1_AD(x,y,xi, 'spline');
y0 = getval(yi)
J = parsetape(eye(n))
