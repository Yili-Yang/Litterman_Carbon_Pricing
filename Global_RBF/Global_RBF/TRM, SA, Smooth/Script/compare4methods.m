% Compare our 4 modified methods: SA with lambda-Smooth, TRM with SA and
% lambda-Smooth, SA with Trace-Smooth and TRM with lambda-Smooth. Using
% Rastrigin function. x_*=rand[-5,5]^n. Also, we count the number of
% evaluations of function value and Hessian matrix. Can change the function
% or any parameters if needed.

myfun=@rast;
kB=1;
L=200;
ubound=1000;
lbound=-1000;
srmin=1;
options = optimoptions(@fmincon,'GradObj','on','Hessian','on',...
    'Algorithm','trust-region-reflective','Display','off');
% options = optimoptions(@fmincon,'Display','off');
k=10;
tracking=0;
f_ssa=zeros(k,1);
f_stsa=zeros(k,1);
f_trmlasmo=zeros(k,1);
f_trmsalasmo=zeros(k,1);
Dim=zeros(k,1);
SAwithLa=zeros(k,2);
TRMwithLa=zeros(k,2);
TRMSAwithLa=zeros(k,2);
SAwithTr=zeros(k,2);

for i=1:k
    L=200;
    n=50+i*5;
    lb=lbound*ones(n,1);
    ub=ubound*ones(n,1);
    varargin=1/40000;
    Dim(i)=n;
    xstar=5*(2*rand(n,1)-1);
    x0=(-lb+ub).*(2*rand(n,1)-1)/2+(lb+ub)/2;
    T0=abs(feval(myfun,x0,varargin));
    Ts=T0*0.9.^(0:199);
    Ts2=10*0.3.^(0:4);
    
    delta=[100*0.5.^(0:0),0];
    [x_ssa,~,SAwithLa(i,1)] = SmoothSA(myfun, x0, xstar, Ts, kB, L, delta, srmin, lb, ub, tracking, varargin);
    [~,f_ssa(i),~,output]=fmincon(myfun,x_ssa,[], [], [], [], lb, ub,[],options,varargin);
    SAwithLa(i,1)=SAwithLa(i,1)+output.funcCount;
    
    [f_trmsalasmo(i),~,TRMSAwithLa(i,1),TRMSAwithLa(i,2)]=TRMSALaSmooth(myfun,x0,xstar,Ts2,500,delta,varargin);
    [f_trmlasmo(i),~,TRMwithLa(i,1),TRMwithLa(i,2)]=TRMLaSmooth(myfun , x0 , xstar, delta , varargin);
    
    Ts=T0*0.9.^(0:199);
    delta=[0.4*0.8.^(0:0),0];
    [x_stsa,~,SAwithTr(i,1),SAwithTr(i,2)] = SmoothTraceSA(myfun, x0, Ts, kB, L, delta, srmin, lb, ub, tracking, varargin);
    [~,f_stsa(i),~,output]=fmincon(myfun,x_stsa,[], [], [], [], lb, ub,[],options,varargin);
    SAwithTr(i,1)=SAwithTr(i,1)+output.funcCount;
    SAwithTr(i,2)=SAwithTr(i,2)+output.iterations;
    disp(i);
end

figure;
plot(Dim,f_ssa,'*-',Dim,f_stsa,'o-',Dim,f_trmsalasmo,'s-',Dim,f_trmlasmo,'d-');
legend('SA with \lambda-Smooth','SA with Trace-Smooth',...
    'TRMSA with \lambda-Smooth','TRM with \lambda-Smooth');
format long;
table(Dim,SAwithLa,SAwithTr,TRMSAwithLa,TRMwithLa)