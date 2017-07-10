function [y,g,H] = langer(xx, varargin)

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

    Inn1(ii)=2*(x1-A(ii,1));
    Inn2(ii)=2*(x2-A(ii,2));
    
    yy=exp(-inner/pi)* sin(pi*inner);%yy
    
    gg1(ii)=-Inn1(ii)/pi*yy+Inn1(ii)*pi*new;
    gg2(ii)=-Inn2(ii)/pi*yy+Inn2(ii)*pi*new;
    
    gx1(ii)=-Inn1(ii)/pi*new - Inn1(ii)*pi*yy;
    gx2(ii)=-Inn2(ii)/pi*new- Inn2(ii)*pi*yy;
%      
     
end

y = outer;

if (nargout >= 2)
    g=zeros(2,1);
    
    g(1,1) =c*gx1;
    g(2,1) =c*gx2;
end


if (nargout >= 3)
    H=zeros(2);
    for ii=1:m
        
        H11=-1/pi*Inn1(ii)*gx1(ii)-2/pi*new-pi*Inn1(ii)*gg1(ii)-2*pi*yy;
        H22=-1/pi*Inn2(ii)*gx2(ii)-2/pi*new-pi*Inn2(ii)*gg2(ii)-2*pi*yy;
        H21=-1/pi*Inn1(ii)*gx2(ii)-pi*Inn1(ii)*gg2(ii);
        
        H(1,1)=H(1,1)+c(ii)*H11;
        H(2,2)=H(2,2)+c(ii)*H22;
        H(2,1)=H(2,1)+c(ii)*H21;
        
    end
    H(1,2)=H(2,1);
    
end

end