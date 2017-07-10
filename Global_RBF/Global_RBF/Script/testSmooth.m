% Compare RBF method, RBF with lambda-Smooth, and RBF with Trace-Smooth.
% (Cubic, multiquadric model)
% Compare f+g+RBF Hessian and f+g+RBF Hessian with lambda-Smooth
% (Cubic, multiquadric model)
% Compare Quasi-Newton and Quasi-Newton with lambda-Smooth

lb=-20; ub=20; m=2; varargin=1/40000; 
gamma=1; deg=-1;
myfun=@rast; it=zeros(1,20);

f_c=zeros(1,20);   iter_c=zeros(1,20); 
f_mq=zeros(1,20);  iter_mq=zeros(1,20); 
f_cl=zeros(1,20);  iter_cl=zeros(1,20);
f_ct=zeros(1,20);  iter_ct=zeros(1,20); 
f_mql=zeros(1,20); iter_mql=zeros(1,20);
f_mqt=zeros(1,20); iter_mqt=zeros(1,20);

x_c=zeros(1,20);   g_c=zeros(1,20);
x_mq=zeros(1,20);  g_mq=zeros(1,20);
x_cl=zeros(1,20);  g_cl=zeros(1,20);
x_ct=zeros(1,20);  g_ct=zeros(1,20);
x_mql=zeros(1,20); g_mql=zeros(1,20);
x_mqt=zeros(1,20); g_mqt=zeros(1,20);
 
f_cgl=zeros(1,20);  iter_cgl=zeros(1,20);
f_cg=zeros(1,20);   iter_cg=zeros(1,20); 
f_mqgl=zeros(1,20); iter_mqgl=zeros(1,20);
f_mqg=zeros(1,20);  iter_mqg=zeros(1,20);

x_cgl=zeros(1,20);  g_cgl=zeros(1,20);
x_cg=zeros(1,20);   g_cg=zeros(1,20);
x_mqgl=zeros(1,20); g_mqgl=zeros(1,20);
x_mqg=zeros(1,20);  g_mqg=zeros(1,20);

f_qn=zeros(1,20);  fcount=zeros(1,20);   gcount=zeros(1,20);
f_qnl=zeros(1,20); fcount_l=zeros(1,20); gcount_l=zeros(1,20);

x_qn=zeros(1,20);  g_qn=zeros(1,20);
x_qnl=zeros(1,20); g_qnl=zeros(1,20);

for i=1:20
    it(i)=i;
    dim=i;
    x=(-lb+ub).*(2*rand(m,dim)-1)/2+(lb+ub)/2;
    f=zeros(m,1);
    
    for j=1:m
        f(j)=myfun(x(j,:),varargin);
    end
    
    ind=find(f==min(f));
    Ls=[10*0.8.^(0:2),0];
    Ds=[0.4.^(0:2),0];
    xstar=3*(2*rand(dim,1)-1);
    
    useg=0;
    method='cubic';
    [f_c(i),xc,iter_c(i)]=RBFTRM(myfun,x,f,ind,method,deg,gamma,useg,varargin);
    [f_cl(i),xcl,iter_cl(i)]=RBFTRM_lsmooth(myfun,x,f,ind,xstar,Ls,method,deg,gamma,useg,varargin);
    [f_ct(i),xct,iter_ct(i)]=RBFTRM_tsmooth(myfun,x,f,ind,Ds,method,deg,gamma,varargin);
    [~,g]=feval(myfun,xc,varargin);
    x_c(i)=norm(xc); g_c(i)=norm(g);
    [~,g]=feval(myfun,xcl,varargin);
    x_cl(i)=norm(xcl); g_cl(i)=norm(g);
    [~,g]=feval(myfun,xct,varargin);
    x_ct(i)=norm(xct); g_ct(i)=norm(g);

    method='multiquadric1';
    [f_mq(i),xmq,iter_mq(i)]=RBFTRM(myfun,x,f,ind,method,deg,gamma,useg,varargin);
    [f_mql(i),xmql,iter_mql(i)]=RBFTRM_lsmooth(myfun,x,f,ind,xstar,Ls,method,deg,gamma,useg,varargin);
    [f_mqt(i),xmqt,iter_mqt(i)]=RBFTRM_tsmooth(myfun,x,f,ind,Ds,method,deg,gamma,varargin);
 
    [~,g]=feval(myfun,xmq,varargin);
    x_mq(i)=norm(xmq); g_mq(i)=norm(g);
    [~,g]=feval(myfun,xmql,varargin);
    x_mql(i)=norm(xmql); g_mql(i)=norm(g);
    [~,g]=feval(myfun,xmqt,varargin);
    x_mqt(i)=norm(xmqt); g_mqt(i)=norm(g);    
    
    useg=1;
    method='cubic';
    [f_cg(i),xcg,iter_cg(i)]=RBFTRM(myfun,x,f,ind,method,deg,gamma,useg,varargin);
    [f_cgl(i),xcgl,iter_cgl(i)]=RBFTRM_lsmooth(myfun,x,f,ind,xstar,Ls,method,deg,gamma,useg,varargin);
    method='multiquadric1';
    [f_mqg(i),xmqg,iter_mqg(i)]=RBFTRM(myfun,x,f,ind,method,deg,gamma,useg,varargin);
    [f_mqgl(i),xmqgl,iter_mqgl(i)]=RBFTRM_lsmooth(myfun,x,f,ind,xstar,Ls,method,deg,gamma,useg,varargin);
    
    [~,g]=feval(myfun,xcg,varargin);
    x_cg(i)=norm(xcg); g_cg(i)=norm(g);
    [~,g]=feval(myfun,xcgl,varargin);
    x_cgl(i)=norm(xcgl); g_cgl(i)=norm(g);
    [~,g]=feval(myfun,xmqg,varargin);
    x_mqg(i)=norm(xmqg); g_mqg(i)=norm(g);
    [~,g]=feval(myfun,xmqgl,varargin);
    x_mqgl(i)=norm(xmqgl); g_mqgl(i)=norm(g);
    
    [f_qn(i),xqn,fcount(i),gcount(i)]=quasi_newton(myfun,x(ind,:)',varargin);
    [f_qnl(i),xqnl,fcount_l(i),gcount_l(i)]=quasi_newton_lsmooth(myfun,x(ind,:)',xstar,Ls,varargin);
    
    [~,g]=feval(myfun,xqnl,varargin);
    x_qnl(i)=norm(xqnl); g_qnl(i)=norm(g);
    [~,g]=feval(myfun,xqn,varargin);
    x_qn(i)=norm(xqn); g_qn(i)=norm(g);
    
    disp(i);
end

figure;
subplot(2,2,1);
plot(it,f_c,'d-',it,f_cl,'s-',it,f_ct,'o-');
legend('Cubic','Cubic-Lsmooth','Cubic-Tsmooth');
title('Func Val');
xlabel('Dimension');
ylabel('Func Val');

subplot(2,2,2);
plot(it,iter_c,'d-',it,iter_cl,'s-',it,iter_ct,'o-');
legend('Cubic','Cubic-Lsmooth','Cubic-Tsmooth');
title('Iteration');
xlabel('Dimension');
ylabel('Iteration');

subplot(2,2,3);
plot(it,x_c,'d-',it,x_cl,'s-',it,x_ct,'o-');
legend('Cubic','Cubic-Lsmooth','Cubic-Tsmooth');
title('Norm of x');
xlabel('Dimension');
ylabel('Norm of x');

subplot(2,2,4);
plot(it,g_c,'d-',it,g_cl,'s-',it,g_ct,'o-');
legend('Cubic','Cubic-Lsmooth','Cubic-Tsmooth');
title('Norm of g');
xlabel('Dimension');
ylabel('Norm of g');

figure;
subplot(2,2,1);
plot(it,f_mq,'d-',it,f_mql,'s-',it,f_mqt,'o-');
legend('Multiquadric','Multiquadric-Lsmooth','Multiquadric-Tsmooth');
title('Func Val');
xlabel('Dimension');
ylabel('Func Val');

subplot(2,2,2);
plot(it,iter_mq,'d-',it,iter_mql,'s-',it,iter_mqt,'o-');
legend('Multiquadric','Multiquadric-Lsmooth','Multiquadric-Tsmooth');
title('Iteration');
xlabel('Dimension');
ylabel('Iteration');

subplot(2,2,3);
plot(it,x_mq,'d-',it,x_mql,'s-',it,x_mqt,'o-');
legend('Multiquadric','Multiquadric-Lsmooth','Multiquadric-Tsmooth');
title('Norm of x');
xlabel('Dimension');
ylabel('Norm of x');

subplot(2,2,4);
plot(it,g_mq,'d-',it,g_mql,'s-',it,g_mqt,'o-');
legend('Multiquadric','Multiquadric-Lsmooth','Multiquadric-Tsmooth');
title('Norm of g');
xlabel('Dimension');
ylabel('Norm of g');

figure;
subplot(2,2,1);
plot(it,f_mqg,'d-',it,f_mqgl,'s-',it,f_cg,'o-',it,f_cgl,'*-');
legend('Multiquadric-g','Multiquadric-g-Lsmooth','Cubic-g','Cubic-g-Lsmooth')
title('Func Val');
xlabel('Dimension');
ylabel('Func Val');

subplot(2,2,2);
plot(it,iter_mqg,'d-',it,iter_mqgl,'s-',it,iter_cg,'o-',it,iter_cgl,'*-');
legend('Multiquadric-g','Multiquadric-g-Lsmooth','Cubic-g','Cubic-g-Lsmooth')
title('Iteration');
xlabel('Dimension');
ylabel('Iteration');

subplot(2,2,3);
plot(it,x_mqg,'d-',it,x_mqgl,'s-',it,x_cg,'o-',it,x_cgl,'*-');
legend('Multiquadric-g','Multiquadric-g-Lsmooth','Cubic-g','Cubic-g-Lsmooth')
title('Norm of x');
xlabel('Dimension');
ylabel('Norm of x');

subplot(2,2,4);
plot(it,g_mqg,'d-',it,g_mqgl,'s-',it,g_cg,'o-',it,g_cgl,'*-');
legend('Multiquadric-g','Multiquadric-g-Lsmooth','Cubic-g','Cubic-g-Lsmooth')
title('Norm of g');
xlabel('Dimension');
ylabel('Norm of g');

figure;
subplot(2,2,1);
plot(it,f_cg,'o-',it,f_cgl,'*-');
legend('Cubic-g','Cubic-g-Lsmooth')
title('Func Val');
xlabel('Dimension');
ylabel('Func Val');

subplot(2,2,2);
plot(it,iter_cg,'o-',it,iter_cgl,'*-');
legend('Cubic-g','Cubic-g-Lsmooth')
title('Iteration');
xlabel('Dimension');
ylabel('Iteration');

subplot(2,2,3);
plot(it,x_cg,'o-',it,x_cgl,'*-');
legend('Cubic-g','Cubic-g-Lsmooth')
title('Norm of x');
xlabel('Dimension');
ylabel('Norm of x');

subplot(2,2,4);
plot(it,g_cg,'o-',it,g_cgl,'*-');
legend('Cubic-g','Cubic-g-Lsmooth')
title('Norm of g');
xlabel('Dimension');
ylabel('Norm of g');


figure;
subplot(2,2,1);
plot(it,f_qn,'d-',it,f_qnl,'s-');
legend('Quasi-Newton','Quasi-Newton-Lsmooth');
title('Func Val');
xlabel('Dimension');
ylabel('Func Val');

subplot(2,2,2);
plot(it,gcount,'d-',it,gcount_l,'s-',it,fcount,'o-',it,fcount_l,'*-');
legend('gcount of QN','gcount of QN-L','fcount of QN','fcount of QN-L');
title('Num of Evals');
xlabel('Dimension');
ylabel('Num of Evals');

subplot(2,2,3);
plot(it,x_qn,'d-',it,x_qnl,'s-');
legend('Quasi-Newton','Quasi-Newton-Lsmooth');
title('Norm of x');
xlabel('Dimension');
ylabel('Norm of x');

subplot(2,2,4);
plot(it,g_qn,'d-',it,g_qnl,'s-');
legend('Quasi-Newton','Quasi-Newton-Lsmooth');
title('Norm of g');
xlabel('Dimension');
ylabel('Norm of g');