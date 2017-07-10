%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                          
%     This demo shows how to use ADAMAT package to       
%     compute  Jacobian  matrices.    
%
%                       
%                     July, 2008
%
%  Source code for Example 3.2.1 in Section 3.2 in User's Guide
%
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

%                                                          
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%      Desciption of 'feval' for vector mapping function
%
%  -- F = feval(fun,x)
%       evaluate the function
%  -- F = feval(fun, x, Extra)
%       evaluate function with parameter in Extra
%  -- [F, J] = feval(fun, x, Extra)
%        evaluate function and Jacobian matrix. If fun is a 
%        scalar function, J is the gradient of fun
%  -- [F, M] = feval(fun, x, Extra, options)
%        compute product of J*V or W'*V in M, depending on 
%        options.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%        Vector Mapping   ( f : R^n --> R^n )
%
%
% Set tge problem size
n = 5;                   % size of the vector variable
%  A class for seamless computation of derivatives via AD
%  Set the differentiated function to be 'Broyden'
myfun = ADfun('broyden');

% Set the independent variable x as an 'all ones' vector
x = ones(n,1);  
% Compute the function value at x
display(' Compute function value of broyden at x');
F = feval(myfun, x)      % function value at x

%  evaluate function value and Jacobian matrix at x
%  f is the function value, J is the Jacobian matrix
display('Compute function value and J, Jacobian of broyden at x');
[F, J] = feval(myfun, x)
%
% using forwrd mode to compute JV via calling feval with "options"
%
%  set up the argument option to be forward mode and V
display('Compute function value and  J*V at x by forward mode');
V = ones(n,3);
options = setopt('forwprod', V);
%  call feval to compute the function value and JV with new set up
%  "option"
[F, JV] = feval(myfun, x, [], options)
%
% using the reverse mode to compute JTW via calling feval
%
% set up the argument option to be reverse mode and W
display('Compute function value and  J^T*W at x by reverse mode');
W = ones(n,3);
options = setopt('revprod', W);
% call feval to compute the function value and J'W with new
% set up "options"
[F, JTW] = feval(myfun, x, [], options)
