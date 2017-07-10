function y = sample1(x,m)

y = zeros(m,1);
for i = 1 : m
    y(i) = x(i)*x(i);
end