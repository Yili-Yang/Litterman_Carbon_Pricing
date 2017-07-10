lb=-200; ub=200; myfun=@rast;
dim=20;
x0=(-lb+ub).*(2*rand(1,dim)-1)/2+(lb+ub)/2;
options = optimoptions(@fminunc,'GradObj','on','Hessian','off',...
    'Algorithm','quasi-newton','Display','iter-detailed');
[x1,f1,~,output]=fminunc(myfun,x0,options)