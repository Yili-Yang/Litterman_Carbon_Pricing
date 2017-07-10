function [ coeff ] = RBFPlot ( x , f , method , pics, lb, ub)
% This function draws the figure of RBF model 

[m,n]=size(x);

if (m~=length(f))
    error('size does not match!');
end
phi=zeros(m);
for i=1:m
    for j=1:m
        if(i~=j)
        phi(i,j)=method(norm(x(i,:)-x(j,:)));
        end
    end
end

P=[x,ones(m,1)];
M=[phi,P;P',zeros(n+1)];
F=[f;zeros(n+1,1)];
coeff=M\F;

if(pics==1)
    if(n==2)
        X =lb:(ub-lb)/100:ub;
        Y = X;
        figure
        VAL = zeros(length(X),length(Y));
        for i=1:length(X)
            for j=1:length(Y)
                val=0;
                for l=1:m
                    val=val+coeff(l)*method(norm([X(i),Y(j)]-x(l,:)));
                end
                VAL(i,j)=val+coeff(m+1:m+n)'*[X(i);Y(j)]+coeff(m+n+1);
            end
        end
        surf(X,Y,VAL);
    elseif(n==1)
        figure
        X =lb:(ub-lb)/100:ub;
        VAL=zeros(1,length(X));
        for i=1:length(X)
            val=0;
            for j=1:m
                val=val+coeff(j)*method(norm(X(i)-x(j)));
            end
            VAL(i)=val+coeff(m+1:m+n)'*X(i)+coeff(m+n+1);
        end
        plot(X,VAL);
    end
end

end
