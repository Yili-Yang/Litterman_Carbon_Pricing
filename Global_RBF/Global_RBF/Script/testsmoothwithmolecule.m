% using 1-D molecule function to test the smooth technique.

lb=-1; ub=1; m=2; varargin=1/40000; 
gamma=1; deg=-1;
myfun=@mol1d; it=zeros(1,20);

f_c=zeros(1,20);   iter_c=zeros(1,20); 
f_cl=zeros(1,20);  iter_cl=zeros(1,20);
f_ct=zeros(1,20);  iter_ct=zeros(1,20); 
 
f_cgl=zeros(1,20);  iter_cgl=zeros(1,20);
f_cg=zeros(1,20);   iter_cg=zeros(1,20); 

f_qn=zeros(1,20);  fcount=zeros(1,20);   gcount=zeros(1,20);
f_qnl=zeros(1,20); fcount_l=zeros(1,20); gcount_l=zeros(1,20);

% xqn is the global optimum for molecule 1-D problem
load xqn.mat;
xs=xqn;

for i=1:20
    it(i)=i;
    dim=6;
    x=(-lb+ub).*(2*rand(m,dim)-1)/2+(lb+ub)/2;
    f=zeros(m,1);
    xstar=xs+0.5*(2*rand(6,1)-1);
    
    for j=1:m
        f(j)=myfun(x(j,:),varargin);
    end
    
    ind=find(f==min(f));
    Ls=[5*0.8.^(0:2),0];
    Ds=[0.05*0.5.^(0:2),0];

    useg=0;
    method='cubic';
    [f_c(i),xc,iter_c(i)]=RBFTRM(myfun,x,f,ind,method,deg,gamma,useg,varargin);
    [f_cl(i),xcl,iter_cl(i)]=RBFTRM_lsmooth(myfun,x,f,ind,xstar,Ls,method,deg,gamma,useg,varargin);
    [f_ct(i),xct,iter_ct(i)]=RBFTRM_tsmooth(myfun,x,f,ind,Ds,method,deg,gamma,varargin);
 
    useg=1;
    method='cubic';
    [f_cg(i),xcg,iter_cg(i)]=RBFTRM(myfun,x,f,ind,method,deg,gamma,useg,varargin);
    [f_cgl(i),xcgl,iter_cgl(i)]=RBFTRM_lsmooth(myfun,x,f,ind,xstar,Ls,method,deg,gamma,useg,varargin);

    [f_qn(i),xqn,fcount(i),gcount(i)]=quasi_newton(myfun,x(ind,:)',varargin);
    [f_qnl(i),xqnl,fcount_l(i),gcount_l(i)]=quasi_newton_lsmooth(myfun,x(ind,:)',xstar,Ls,varargin);
    
    disp(i);
end

figure;
subplot(2,1,1);
plot(it,f_c,'d-',it,f_cl,'s-',it,f_ct,'o-');
legend('Cubic','Cubic-Lsmooth','Cubic-Tsmooth');
title('Func Val');
xlabel('Dimension');
ylabel('Func Val');

subplot(2,1,2);
plot(it,iter_c,'d-',it,iter_cl,'s-',it,iter_ct,'o-');
legend('Cubic','Cubic-Lsmooth','Cubic-Tsmooth');
title('Iteration');
xlabel('Dimension');
ylabel('Iteration');

figure;
subplot(2,1,1);
plot(it,f_cg,'o-',it,f_cgl,'*-');
legend('Cubic-g','Cubic-g-Lsmooth')
title('Func Val');
xlabel('Dimension');
ylabel('Func Val');

subplot(2,1,2);
plot(it,iter_cg,'o-',it,iter_cgl,'*-');
legend('Cubic-g','Cubic-g-Lsmooth')
title('Iteration');
xlabel('Dimension');
ylabel('Iteration');

figure;
subplot(2,1,1);
plot(it,f_qn,'d-',it,f_qnl,'s-');
legend('Quasi-Newton','Quasi-Newton-Lsmooth');
title('Func Val');
xlabel('Dimension');
ylabel('Func Val');

subplot(2,1,2);
plot(it,gcount,'d-',it,gcount_l,'s-',it,fcount,'o-',it,fcount_l,'*-');
legend('gcount of QN','gcount of QN-L','fcount of QN','fcount of QN-L');
title('Num of Evals');
xlabel('Dimension');
ylabel('Num of Evals');

