function y = sample2(x,m)

y = zeros(m,1);
y = cons(y,x);
for i = 1 : m
    y(i) = x(i)*x(i);
end