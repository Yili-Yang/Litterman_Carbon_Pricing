function y = langer_re(xx, varargin)

d = 2;
m = 5;
c = [1, 2, 5, 2, 3];
A = [3, 5; 5, 2; 2, 1; 1, 4; 7, 9];

Inn1=zeros(5,1);
Inn2=zeros(5,1);
gx1=zeros(5,1);
gx2=zeros(5,1);
gg1=zeros(5,1);
gg2=zeros(5,1);

outer = 0;
x1=xx(1);
x2=xx(2);
for ii = 1:m
    inner = 0;
    for jj = 1:d
        xj = xx(jj);
        Aij = A(ii,jj);
        inner = inner + (xj-Aij)^2;
    end
   
    
    new = exp(-inner/pi) * cos(pi*inner); %y
    
    outer = outer + c(ii) * new;
     
end

y = outer;

