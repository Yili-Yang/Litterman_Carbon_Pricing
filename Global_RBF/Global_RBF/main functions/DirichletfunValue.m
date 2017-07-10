function f = DirichletfunValue(x,DM)

%input
%  x - - row vector
%% prepare test case that A*u=b, where b = boundaryValue(x)
%x1=getval(x);% deriv object to column vector

% x1=getval(x);
% if size(x1,1)==1
%     x1=x1';
% end

if size(x,1)==1
    x = x';
end

B=full(DM.B);
uT=full(DM.uT);
M=DM.M;

% M = numel(getval(x))/4
idr = [1:M, 1:M:(M^2), M:M:(M^2), (M^2-M+1):(M^2)]';
b = full(sparse(idr,ones(4*M,1),x));

B_size = size(B);
b_size = size(b);

u=B*b;
f=sum((uT-u).^2);

f = full(f);

end