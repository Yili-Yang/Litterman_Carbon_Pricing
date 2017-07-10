function y = func_DS(x, Extra)
%
%  reveal the relationship between x and intermediate variables y1,..,yN
%  
%        y_{i+1} = y_i + h*y_i 
%
% INPUT
%  x -- independent variables x
%
% OUTPUT
%  y -- independent variable x and intermediate variables y1,...,yN
%                  [ x  ]
%                  [ y1 ]
%              y = [ :  ]
%                  [ yN ]
%
n = length(x);      
N = Extra.M;    % number of intermediate variables, y1,...,yN

y = zeros(n*(N+1),1);
y(1:n) = x;
x0 = x;
fx = Extra.fkt;
h = Extra.h;

for j = 1 : N
    z = x0 + h*feval(fx, x0, Extra);
    x0 = z;
    y(j*n+1:(j+1)*n) = z;
end

