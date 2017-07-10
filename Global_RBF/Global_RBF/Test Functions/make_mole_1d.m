function [ DM,xmole ] = make_mole_1d (perc_nnz,n)
%create a 1-D molecule problem
%   
y = rand(n,1);
x = ones(n,1) +n*y;
% x(1) = 1;
xmole=x;
DM=sparse(n,n);
for i=1:n
    if i < n
     DM(i,i+1)= abs(x(i)-x(i+1));
     DM(i+1,i) = DM(i,i+1);
    end
    for j=i+2:n
        r = rand;
        if r <= perc_nnz
            DM(i,j) = abs(x(i)-x(j));
            DM(j,i) = DM(i,j);
        end
    end
end



end

