function [f, g] = fcostsmooth(x, k1, l1, l2, delta, eps)

p1 = k1-delta-eps;
p2 = k1-delta+eps;
p3 = k1+delta-eps;
p4 = k1+delta+eps;

% f = x;
% 
% f(x <= p1) = l1;
% 
% con1 = logical((x > p1) .* (x <= p2));
% f(con1) = l1 + (l2-l1)/(2*delta)/(4*eps)*(x(con1)-k1+delta+eps).^2;
% 
% con2 = logical((x > p2) .* (x <= p3));
% f(con2) = (l2-l1)/(2*delta) * (x(con2)-k1) + (l2-l1)/2;
% 
% con3 = logical((x > p3) .* (x <= p4));
% f(con3) = l2 - (l2-l1)/(2*delta)/(4*eps)*(-x(con3)+k1+delta+eps).^2;
% 
% f(x > p4) = l2;

if x <= p1
    f = l1;
    g = 0;
elseif (x > p1) && (x <= p2)
    f = l1 + (l2-l1)/(2*delta)/(4*eps)*(x-k1+delta+eps).^2;
    g = 2*(l2-l1)/(2*delta)/(4*eps)*(x-k1+delta+eps);
elseif (x > p2) && (x <= p3)
    f = (l2-l1)/(2*delta) * (x-k1) + (l2-l1)/2;
    g = (l2-l1)/(2*delta);
elseif (x > p3) && (x <= p4)
    f = l2 - (l2-l1)/(2*delta)/(4*eps)*(-x+k1+delta+eps).^2;
    g = 2*(l2-l1)/(2*delta)/(4*eps)*(-x+k1+delta+eps);
elseif x > p4
    f = l2;
    g = 0;
else
    f = -1;
    g = -1;
end
    
end