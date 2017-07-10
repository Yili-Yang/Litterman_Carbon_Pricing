% Draw the picture of how RBF model approximate the original function

lb=-2; ub=2;
dim=2; m=50;
myfun=@shubert;
pics=1; orig=0;
method=@thinplate;

if(dim==1)
    if(orig==1)
        X=lb:(ub-lb)/100:ub;
        VAL=zeros(1,length(X));
        for i=1:length(X)
            VAL(i)=myfun(X(i));
        end
        plot(X,VAL);
    end
    x=(-lb+ub).*(2*rand(m,dim)-1)/2+(lb+ub)/2;
    f=zeros(m,1);
    for i=1:m
        f(i)=myfun(x(i));
    end
    RBFPlot ( x , f , method , pics, lb, ub );
end

if(dim==2)
    if(orig==1)
        X=lb:(ub-lb)/100:ub;
        Y=X;
        VAL=zeros(length(X),length(Y));
        for i=1:length(X)
            for j=1:length(Y)
                VAL(i,j)=myfun([X(i),Y(j)]);
            end
        end
        figure;
        surf(X,Y,VAL);
    end
    x=(-lb+ub).*(2*rand(m,dim)-1)/2+(lb+ub)/2;
    f=zeros(m,1);
    for i=1:m
        f(i)=myfun(x(i,:));
    end
    RBFPlot ( x , f , method , pics, lb, ub );
end