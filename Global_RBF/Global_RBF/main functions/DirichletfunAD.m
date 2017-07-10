function [f,g]= DirichletfunAD(x,DM)

%input
%  x - - row vector
%% prepare test case that A*u=b, where b = boundaryValue(x)
%x1=getval(x);% deriv object to column vector

% x1=x;
% if size(x1,1)==1
%     x1=x1';
% end

if size(x,1)==1
    x = x';
end

% B=DM.B;
% uT=DM.uT;
% 
% M = numel(x1)/4;
% idr = [1:M, 1:M:(M^2), M:M:(M^2), (M^2-M+1):(M^2)]';
% b = sparse(idr,ones(4*M,1),x1);
% 
% u=B*b;
% f=sum((uT-u).^2);
% 
% len=length(x1);
% g=zeros(len,1);
% for i=1:len
%     ix=idr(i);
%     g(i)=-2*(uT(ix)-u(ix))*sum(B(:,ix));
% end

n = length(x);
myfun = ADfun('DirichletfunValue',1);
options = setgradopt('revprod', n);
[f,g] = feval(myfun,x,DM,options);

g = g';
% [f,g] = Dirichletfun(x,DM);

end
