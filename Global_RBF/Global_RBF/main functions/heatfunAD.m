function [f, g] = heatfunAD(x,DM)

if size(x,1)==1
    x = x';
end

xheatad_size = size(x);

n = length(x);
myfun = ADfun('heatfunValue', 1);
% options = setgradopt('forwprod', n);
[f, g] = feval(myfun, x, DM);
g = g';

end