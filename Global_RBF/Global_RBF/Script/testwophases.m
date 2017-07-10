% test script for quasi-newton, quasi-newton with 2 phases. Quasi-newton
% with lmbda-Smooth and 2 phases of quasi-newton with lambda-Smooth
%
% Phase 1: we use f only (RBF) method to optimiza and get a solution x_bar
% Phase 2: use quasi-newton method with the start point x_bar
%
% At last, draw the figure of final function value and number of evaluation
% of function value

lb=-100; ub=100; m=2; varargin=1/40000;
gamma=1; deg=-1;
myfun=@rast; it=zeros(1,20);

f_c=zeros(1,20);   iter_c=zeros(1,20);
f_cl=zeros(1,20);  iter_cl=zeros(1,20);

x_c=zeros(1,20);   g_c=zeros(1,20);
x_cl=zeros(1,20);  g_cl=zeros(1,20);

f_qn=zeros(1,20);  fcount=zeros(1,20);   gcount=zeros(1,20);
f_qnl=zeros(1,20); fcount_l=zeros(1,20); gcount_l=zeros(1,20);

f_qn2=zeros(1,20);  fcount2=zeros(1,20);   gcount2=zeros(1,20);
f_qnl2=zeros(1,20); fcount_l2=zeros(1,20); gcount_l2=zeros(1,20);

for i=1:20
    it(i)=i;
    dim=i;
    x=(-lb+ub).*(2*rand(m,dim)-1)/2+(lb+ub)/2;
    f=zeros(m,1);
    
    for j=1:m
        f(j)=myfun(x(j,:),varargin);
    end
    
    ind=find(f==min(f));
    Ls=[10*0.3.^(0:2),0];
    xstar=1*(2*rand(dim,1)-1);
    
    useg=0;
    method='cubic';
    % Phase 1: RBF
    [f_c(i),xc,iter_c(i)]=RBFTRM(myfun,x,f,ind,method,deg,gamma,useg,varargin);
    [~,g]=feval(myfun,xc,varargin);
    x_c(i)=norm(xc); g_c(i)=norm(g);
    
    % Phase 2: Quasi-Newton
    [f_qn2(i),xqn2,fcount2(i),gcount2(i)]=quasi_newton(myfun,xc,varargin);
    fcount2(i)=fcount2(i)+iter_c(i)+m;
    
    % Phase 1: RBF with lambda-Smooth
    [f_cl(i),xcl,iter_cl(i)]=RBFTRM_lsmooth(myfun,x,f,ind,xstar,Ls,method,deg,gamma,useg,varargin);
    [~,g]=feval(myfun,xcl,varargin);
    x_cl(i)=norm(xcl); g_cl(i)=norm(g);
    
    % Phase 2: Quasi-Newton with lambda-Smooth
    [f_qnl2(i),xqnl2,fcount_l2(i),gcount_l2(i)]=quasi_newton_lsmooth(myfun,xcl,xstar,Ls,varargin);
    fcount_l2(i)=fcount_l2(i)+iter_cl(i)+m;
    
    % Compare with just Q-N or Q-N with lambda-Smooth
    [f_qn(i),xqn,fcount(i),gcount(i)]=quasi_newton(myfun,x(ind,:)',varargin);
    [f_qnl(i),xqnl,fcount_l(i),gcount_l(i)]=quasi_newton_lsmooth(myfun,x(ind,:)',xstar,Ls,varargin);
    
    disp(i);
    
end

% figure;
% subplot(2,2,1);
% plot(it,f_c,'d-',it,f_cl,'s-');
% legend('Cubic','Cubic-Lsmooth');
% title('Func Val');
% xlabel('Dim');
% ylabel('Func Val');
% 
% subplot(2,2,2);
% plot(it,iter_c,'d-',it,iter_cl,'s-');
% legend('Cubic','Cubic-Lsmooth');
% title('Iteration');
% xlabel('Dim');
% ylabel('Iteration');
% 
% subplot(2,2,3);
% plot(it,x_c,'d-',it,x_cl,'s-');
% legend('Cubic','Cubic-Lsmooth');
% title('Norm of x');
% xlabel('Dim');
% ylabel('Norm of x');
% 
% subplot(2,2,4);
% plot(it,g_c,'d-',it,g_cl,'s-');
% legend('Cubic','Cubic-Lsmooth');
% title('Norm of g');
% xlabel('Dim');
% ylabel('Norm of g');

figure;
subplot(2,1,1);
plot(it,f_qn,'d-',it,f_qn2,'*-');
legend('Quasi-Newton','2 Phases');
title('Quasi-Newton');
xlabel('Dim');
ylabel('Func Val');

subplot(2,1,2);
plot(it,fcount,'d-',it,fcount2,'*-');
legend('Quasi-Newton','2 Phases');
title('Num of Func Evals');
xlabel('Dim');
ylabel('Num of Func Evals');

figure;
subplot(2,1,1);
plot(it,f_qnl,'d-',it,f_qnl2,'*-');
legend('QN-\lambda-Smooth','2 Phases-\lambda-Smooth');
title('Quasi-Newton with \lambda-Smooth');
xlabel('Dim');
ylabel('Func Val');

% figure;
% plot(it,gcount,'d-',it,gcount_l,'s-',it,gcount2,'o-',it,gcount_l2,'*-');
% legend('gcount of QN','gcount of QN-L','gcount of 2 Phases','gcount of 2 Phases-L');
% title('Num of Evals');
% xlabel('Dim');
% ylabel('Num of Evals');

subplot(2,1,2);
plot(it,fcount_l,'d-',it,fcount_l2,'*-');
legend('QN-\lambda-Smooth','2 Phases-\lambda-Smooth');
title('Num of Func Evals');
xlabel('Dim');
ylabel('Num of Func Evals');