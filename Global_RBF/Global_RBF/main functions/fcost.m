function [tc, gd] = fcost(xv, k1v, level1v, level2v, deltav)

n = length(xv);

if nargin < 5
    deltav = ones(n,1)*.25;
end

if nargin < 4
    level2v = ones(n,1);
end

if nargin < 3
    level1v = zeros(n,1);
end

if nargin < 2
    k1v = ones(n,1);
end

epsv = deltav*.1;

tc = 0;
gd = xv;
for i = 1:n
    [ftemp, gtemp] = fcostsmooth(xv(i), k1v(i), level1v(i), level2v(i), deltav(i), epsv(i));
    tc = tc + ftemp;
    gd(i) = gtemp;
end

end