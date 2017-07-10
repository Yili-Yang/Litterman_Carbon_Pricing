function [f, g] = fcostgrad(x, Extra)

x = getval(x);

myfun = ADfun('fcostvalue', 1);
n = length(x);
[f, g] = feval(myfun, x);

end