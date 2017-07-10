function f = fcost1d(x, k1, l1, l2, delta)

p1 = k1-delta;
p2 = k1+delta;

f = x;

f(x <= p1) = l1;
con = logical((x > p1) .* (x <= p2));
f(con) = (l2-l1)/(2*delta) * (x(con)-p1) + l1;
f(x > p2) = l2;

end