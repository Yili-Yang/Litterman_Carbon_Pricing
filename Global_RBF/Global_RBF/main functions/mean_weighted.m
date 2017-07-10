function val = mean_weighted(x,mu,n)

y = mu .* x;
val = sum(y) / n;

end