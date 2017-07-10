function [group] = colorHess(H,p)

[m,n] = size(H);

if nargin < 2
    p = 1:1:n;
    p = p';
end
H = H(p,p);
group = zeros(n,1);
ncol = 0;
sumg=m;

while sumg >  0
    ncol = ncol + 1;
    rows = zeros(m,1);
    index = find(group==0);
    lindex = length(index);
    for i = 1:lindex
        k = index(i);
        if rows(k)==0
            group(k) = ncol;
            rows = rows + H(:,k);
        end
    end
    sumg=sumg-sum(group==ncol);
end
group(p)= group;
