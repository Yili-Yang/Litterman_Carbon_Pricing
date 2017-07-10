function val = mean_feval(x, Extra)

mu = Extra.mu;
n = Extra.n;
y = mu .* x;
val = sum(y) / n;

end