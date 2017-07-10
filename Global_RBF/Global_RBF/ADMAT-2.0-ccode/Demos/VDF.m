function y = VDF(x, Extra)

% the variably dimensioned function (VDF) from the More-Garbow-Hillstrom
% collection. 
%         VDF(x) : R^n --> R^{n+2}

n = length(x);
y = x - 1;
 
i = 1:n;
tmp = sum(i.*(x(i)'-1));
% tmp = 0;
% for  i = 1 : n 
%  tmp = tmp + i*( x(i) -1); 
% end
y(n+1) = tmp; 
y(n+2) = tmp^2;

