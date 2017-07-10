%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
%                     ODE  y' = y
%   One step Euler method to compute an approximation y_k to a desired
%   final state y(T). Solve this ODE via the expanded Newton method.
%   
%
%                     
%                     July, 2008
%
%       Source code for Example 6.2.1 in Section 6.2 in User's Guide
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% initialization
p = 5;            % number of intermediate variables   
N = 8;            % size of original problem
tol = 1e-13;      % convergence tolerance
itNum = 40;       % maximum number of iteration
h = 1e-8;         % step size

% initialize the random seed
rand('seed',0);
% set the target function's input point xT
xT = rand(N,1)

% set the expanded function F^E, F and G

func = 'Exp_DS';  % Expanded function with independent variables, x, y1,
                  % y2,...., yM
func_y = 'func_DS';  % function revealing relation between x, y1,y2,...,yM
funG = 'Gx';      % function funG on the right hand side of expanded Newton

% Set parameters required in "func" and "func_y"
Extra.N = N;     % size of original problem
Extra.M = p;     % number of intermediate variables
Extra.u0 = xT;   % input variable for the target function phi(xT)
Extra.fkt = @fx;       % function f on the right hand side of ODE
Extra.phi = @exp;      % target function phi
Extra.h = h;           % step size of one step Euler method

% set the starting point of x
x = ones(N, 1);

% solve the ODE by the expanded Newton method
[x, fval, it] = newton_expand(func, func_y, funG, x,p, tol, itNum, Extra)

% compare the computed solution with the target function value
fprintf('The difference between computed solution with the target function value\n');
fprintf('norm(x-exp(T)) = %e\n',norm(x-exp(xT)));

