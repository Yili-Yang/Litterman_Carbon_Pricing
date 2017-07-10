myfun=@levy;
kB=1;
% L=200;
lbound=-1000;
ubound=1000;
srmin=1;
% options = optimoptions(@fmincon,'GradObj','on','Hessian','on',...
%     'Algorithm','trust-region-reflective','Display','off');

options = optimoptions(@fmincon,'GradObj','off','Hessian','off',...
    'Display','off');

tracking=1;
varargin=[];
n=20;
lb=lbound*ones(n,1);
ub=ubound*ones(n,1);
x0=(-lb+ub).*(2*rand(n,1)-1)/2+(lb+ub)/2;
T0=abs(feval(myfun,x0,varargin));

% T0=10;
% Ts=T0*0.9.^(0:199);
% 
% delta=[100*0.5.^(0:4),0];
% [x_ssa,~] = SmoothSA(myfun, x0, xstar, Ts, kB, L, delta, srmin, lb, ub, tracking);
% [~,f_ssa]=fmincon(myfun,x_ssa,[], [], [], [], lb, ub,[],options);
% 
% delta=[0.4*0.6.^(0:4),0];
% [x_stsa,~] = SmoothTraceSA(myfun, x0, Ts, kB, L, delta, srmin, lb, ub, tracking);
% [~,f_stsa]=fmincon(myfun,x_stsa,[], [], [], [], lb, ub,[],options);

L=200;
Ts=T0*0.9.^(0:199);
[x_psa,~] = PureSA(myfun, x0, Ts, kB, L, srmin, lb, ub, tracking,varargin);
[~,f_psa]=fmincon(myfun,x_psa,[], [], [], [], lb, ub,[],options,varargin);

% disp('srmin=1,Ts=T0*0.9.^(0:199)')
% disp('lambda-Smooth final result:');
% disp(f_ssa);
% disp('Trace-Smooth final result:');
% disp(f_stsa);
disp('Pure SA final result:');
disp(f_psa);

srmin=0;
% L=200;
% Ts=T0*0.9.^(0:199);
% delta=[100*0.5.^(0:4),0];
% [x_ssa,~] = SmoothSA(myfun, x0, xstar, Ts, kB, L, delta, srmin, lb, ub, tracking);
% [~,f_ssa]=fmincon(myfun,x_ssa,[], [], [], [], lb, ub,[],options);
% 
% delta=[0.4*0.6.^(0:4),0];
% [x_stsa,~] = SmoothTraceSA(myfun, x0, Ts, kB, L, delta, srmin, lb, ub, tracking);
% [~,f_stsa]=fmincon(myfun,x_stsa,[], [], [], [], lb, ub,[],options);

[x_psa,~] = PureSA(myfun, x0, Ts, kB, L, srmin, lb, ub, tracking,varargin);
[~,f_psa]=fmincon(myfun,x_psa,[], [], [], [], lb, ub,[],options,varargin);

% disp('srmin=0,Ts=T0*0.9.^(0:199)')
% disp('lambda-Smooth final result:');
% disp(f_ssa);
% disp('Trace-Smooth final result:');
% disp(f_stsa);
disp('Pure SA final result:');
disp(f_psa);

srmin=0;
% L=200;
% Ts=[T0*0.9.^(0:39),T0*0.9^39*ones(1,160)];
% delta=[100*0.5.^(0:4),0];
% [x_ssa,~] = SmoothSA(myfun, x0, xstar, Ts, kB, L, delta, srmin, lb, ub, tracking);
% [~,f_ssa]=fmincon(myfun,x_ssa,[], [], [], [], lb, ub,[],options);
% 
% delta=[0.4*0.6.^(0:4),0];
% [x_stsa,~] = SmoothTraceSA(myfun, x0, Ts, kB, L, delta, srmin, lb, ub, tracking);
% [~,f_stsa]=fmincon(myfun,x_stsa,[], [], [], [], lb, ub,[],options);

Ts=[T0*0.9.^(0:99),T0*0.9^99*ones(1,100)];
[x_psa,~] = PureSA(myfun, x0, Ts, kB, L, srmin, lb, ub, tracking,varargin);
[~,f_psa]=fmincon(myfun,x_psa,[], [], [], [], lb, ub,[],options,varargin);

% disp('srmin=0,Ts=[T0*0.9.^(0:99),T0*0.9^99*ones(1,100)]')
% disp('lambda-Smooth final result:');
% disp(f_ssa);
% disp('Trace-Smooth final result:');
% disp(f_stsa);
disp('Pure SA final result:');
disp(f_psa);