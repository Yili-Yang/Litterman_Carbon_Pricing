X =-5:0.1:5;
Y = X;
figure
for k=1:4
    delta=0.07*(k-1);
    myfun=ADfun('drop',1);
    VAL = zeros(length(X),length(Y));
    for i=1:length(X)
        for j=1:length(Y)
            VAL(i,j) = plotfunction(myfun,[X(i);Y(j)],delta,[]);
        end
    end
    subplot(2,2,k);
    surf(X,Y,VAL);
    zlim([-1,0]);
end