% test script for quasi-newton, quasi-newton with 2 phases. Quasi-newton
% with lmbda-Smooth and 2 phases of quasi-newton with lambda-Smooth
%
% Phase 1: we use f only (RBF) method with lambda-Smooth to optimiza and 
% get a solution x_bar
% Phase 2: use quasi-newton method with the start point x_bar
%
% At last, draw the figure of final function value and number of evaluation
% of function value

lb=-100; ub=100; m=2; varargin=1/40000;
gamma=1; deg=-1;
myfun=@rast; it=zeros(1,20);

f_qn=zeros(1,20);  fcount=zeros(1,20);   gcount=zeros(1,20);
f_qnl=zeros(1,20); fcount_l=zeros(1,20); gcount_l=zeros(1,20);

f_qn2=zeros(1,20);  fcount2=zeros(1,20);   gcount2=zeros(1,20);

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
    
    % Phase 1: RBF with lambda-Smooth
    [f_cl,xcl,iter_cl]=RBFTRM_lsmooth(myfun,x,f,ind,xstar,Ls,method,deg,gamma,useg,varargin);
   
    % Phase 2: Quasi-Newton method
    [f_qn2(i),xqn2,fcount2(i),gcount2(i)]=quasi_newton(myfun,xcl,varargin);
    
    % Compare with just Q-N or Q-N with lambda-Smooth
    [f_qn(i),xqn,fcount(i),gcount(i)]=quasi_newton(myfun,x(ind,:)',varargin);
    [f_qnl(i),xqnl,fcount_l(i),gcount_l(i)]=quasi_newton_lsmooth(myfun,x(ind,:)',xstar,Ls,varargin);
    
    fcount2(i)=fcount2(i)+iter_cl+m;

    disp(i);
    
end

figure;
subplot(2,1,1);
plot(it,f_qn,'d-',it,f_qn2,'*-');
legend('Quasi-Newton','2 Phases');
title('f only with \lambda-Smooth and Q-N Compare Q-N');
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
plot(it,f_qnl,'d-',it,f_qn2,'*-');
legend('QN-\lambda-Smooth','2 Phases');
title('f only with \lambda-Smooth and Q-N Compare Q-N with \lambda-Smooth');
xlabel('Dim');
ylabel('Func Val');

subplot(2,1,2);
plot(it,fcount_l,'d-',it,fcount2,'*-');
legend('QN-\lambda-Smooth','2 Phases');
title('Num of Func Evals');
xlabel('Dim');
ylabel('Num of Func Evals');