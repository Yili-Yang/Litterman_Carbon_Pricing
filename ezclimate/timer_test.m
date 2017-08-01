profile on
for count = 1:10
    fun = @(x)x^100+log(x)+x^(-100);
    start =2;
    [x,fval,exitflag,output,lambda,grad,hessian]= fmincon(fun,start);
end
profile off
