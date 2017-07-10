
myfun=ADfun('ackley',1);
fun='ackley';
kB=1;
L=100;
ubound=30;
lbound=-30;
srmin=0.03;
% options = optimoptions(@fmincon,'GradObj','on','Hessian','on',...
%     'Algorithm','trust-region-reflective','Display','off');
options = optimoptions(@fmincon,'Display','off');
k=5;
tracking=0;
f_ssa=zeros(k,1);
f_stsa=zeros(k,1);
f_psa=zeros(k,1);
f_fmin=zeros(k,1);
it=zeros(1,k);

for i=1:k
    
    n=10;
    lb=lbound*ones(n,1);
    ub=ubound*ones(n,1);
    varargin=[];
    it(i)=i;
    xstar=zeros(n,1);
    x0=(-lb+ub).*(2*rand(n,1)-1)/2+(lb+ub)/2;
    T0=abs(feval(myfun,x0,varargin));
%     T0=10;
    Ts=T0*0.9.^(0:99);
    
    delta=[10*0.5.^(0:3),0];
    [x_ssa,~] = SmoothSA(myfun, x0, xstar, Ts, kB, L, delta, srmin, lb, ub, tracking, varargin);
    [~,f_ssa(i)]=fmincon(myfun,x_ssa,[], [], [], [], lb, ub,[],options,varargin);

    delta=[0.3*0.8.^(0:3),0];
    [x_stsa,~] = SmoothTraceSA(myfun, fun, x0, Ts, kB, L, delta, srmin, lb, ub, tracking, varargin);
    [~,f_stsa(i)]=fmincon(myfun,x_stsa,[], [], [], [], lb, ub,[],options,varargin);

    [x_psa,~] = PureSA(myfun, x0, Ts, kB, L, srmin, lb, ub, tracking, varargin);
    [~,f_psa(i)]=fmincon(myfun,x_psa,[], [], [], [], lb, ub,[],options,varargin);
 
%     [x_sab,~]=simulannealbnd(myfun,x0,lb,ub);
    [~,f_fmin(i)]=fmincon(myfun,x0,[], [], [], [], lb, ub,[],options,varargin);

    disp(i)
end


figure;
plot(it,f_ssa,'*-',it,f_stsa,'o-',it,f_psa,'+-',it,f_fmin,'v-');
legend('lambda-Smooth','Trace-Smooth','Pure SA','fmincon');
%title('');


figure;
plot(it,f_ssa,'*-',it,f_stsa,'o-',it,f_psa,'+-');
legend('lambda-Smooth','Trace-Smooth','Pure SA');
%title('Ackley. n=2 to 20');

