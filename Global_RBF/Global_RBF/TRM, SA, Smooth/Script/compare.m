% Compare the whole 7 method we dicovered.

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
f_psa=zeros(k,1);
f_trm=zeros(k,1);
f_trmsa=zeros(k,1);
f_trmsatrsmo=zeros(k,1);
f_trmsalasmo=zeros(k,1);
it=zeros(1,k);

for i=1:k
    
    n=50+5*i;
    lb=lbound*ones(n,1);
    ub=ubound*ones(n,1);
    varargin=1/40000;
    it(i)=n;
    xstar=zeros(n,1);
    x0=(-lb+ub).*(2*rand(n,1)-1)/2+(lb+ub)/2;
    T0=abs(feval(myfun,x0,varargin));
%     T0=10;
    Ts=T0*0.9.^(0:199);
    Ts2=10*0.3.^(0:19);
    
    delta=[10*0.5.^(0:3),0];
    [x_ssa,~] = SmoothSA(myfun, x0, xstar, Ts, kB, L, delta, srmin, lb, ub, tracking, varargin);
    [~,f_ssa(i)]=fmincon(myfun,x_ssa,[], [], [], [], lb, ub,[],options,varargin);
    
    [f_trmsa(i),~]=TRMSA(myfun,x0,Ts2,500,varargin);
    [f_trmsalasmo(i),~,~,~]=TRMSALaSmooth(myfun,x0,xstar,Ts2,500,delta,varargin);
    
    
    delta=[0.4*0.8.^(0:3),0];
    [x_stsa,~] = SmoothTraceSA(myfun, x0, Ts, kB, L, delta, srmin, lb, ub, tracking, varargin);
    [~,f_stsa(i)]=fmincon(myfun,x_stsa,[], [], [], [], lb, ub,[],options,varargin);
    delta=[4*0.8.^(0:3),0];
    [f_trmsatrsmo(i),~]=TRMSATrSmooth(myfun,x0,Ts2,500,delta,varargin);
   
    [x_psa,~] = PureSA(myfun, x0, Ts, kB, L, srmin, lb, ub, tracking, varargin);
    [~,f_psa(i)]=fmincon(myfun,x_psa,[], [], [], [], lb, ub,[],options,varargin);
 
%     [x_sab,~]=simulannealbnd(myfun,x0,lb,ub);
%     [~,f_fmin(i)]=fmincon(myfun,x0,[], [], [], [], lb, ub,[],options,varargin);
    
    [f_trm(i),~,~]=TRM(myfun,x0,varargin);
    disp(i)
end


figure;
plot(it,f_ssa,'*-',it,f_stsa,'o-',it,f_psa,'+-',it,f_trm,'v-',it,f_trmsa,...
    'x-',it,f_trmsalasmo,'s-',it,f_trmsatrsmo,'d-');
legend('lambda-Smooth','Trace-Smooth','Pure SA','TRM','TRMSA',...
    'TRMSA-LaSmooth','TRMSA-TRSmooth');
%title('');
