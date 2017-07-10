k = 10;
n = 100;
A = rand(n);
b = rand(n,1);
W = eye(n);
WW = W(:,:, ones(1,n));
A = deriv(A, WW);
b = deriv(b, W);
t = cputime;
for i = 1 : n
    x = A\b;
end
t = cputime - t
    