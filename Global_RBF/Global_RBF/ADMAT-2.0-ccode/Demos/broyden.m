function fvec= broyden(x, Extra)
%
% Evaluate  the Broyden nonlinear equations test function.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUT:
%       x - The current point (column vector). When it is an
%           object of deriv class, the fundamental operations
%           will be overloaded automatically.
%   Extra - Parameters for the function, but you have to keep 
%           it in the function definition to keep the ADMAT 
%           package correctly even if it is empty.
%     
%
% OUTPUT:
%  fvec - The (vector) function value at x. When x  is an object
%         of deriv class, fvec will be an object of deriv class 
%         as well. There are two fields in fvec. One is the 
%         function value at x, the other is the Jacobian matrix
%         at x.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Evaluate the vector function
  n = length(x); 
% Initislize fvec. It is a must in defining a function for 
% ADMAT.
% fvec = deriv(zeros(getval(n),1), speye(getval(n)));
fvec=zeros(n,1);
  i=2:(n-1);
  fvec(i)= (3-2.*x(i)).*x(i)-x(i-1)-2.*x(i+1) + 1;
  fvec(n)= (3-2.*x(n)).*x(n)-x(n-1)+1;
  fvec(1)= (3-2.*x(1)).*x(1)-2.*x(2)+1;