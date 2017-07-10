function [y,g] = spheref(xx,varargin)
d = length(xx);
sum = 0;
for ii = 1:d
	xi = xx(ii);
	sum = sum + xi^2;
end

y = sum;

if(nargout==2)
    g=2*xx;
end

end
