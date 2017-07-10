function y = OriFun(x, n, Ax)
%
%     function y = F(A^{-1}F(x)),
%  where F is the Broyden function and the nonzero of A is A(i,j) = x(j).
%
%
% construct A
A = full(Ax) .* x(:,ones(1,n))';
% compute F(x)
y = broyden(x);
y = A\y;
y = broyden(y);


