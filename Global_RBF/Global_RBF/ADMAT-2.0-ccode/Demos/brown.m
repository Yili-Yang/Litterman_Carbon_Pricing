function value = brown(x,Extra)
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
%  value - The (vector) function value at x. When x  is an object
%         of deriv class, fvec will be an object of deriv class 
%         as well. There are two fields in fvec. One is the 
%         function value at x, the other is the Jacobian matrix
%         at x.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Evaluate the size of input.
  n=length(x);
 % initialize y. It is a must in defining a function for ADMAT
  y=zeros(n,1);
 % Evaluate the length 
  i=1:(n-1);
  y(i)=(x(i).^2).^(x(i+1).^2+1);
  y(i)=y(i)+(x(i+1).^2).^(x(i).^2+1);
  value=sum(y);
