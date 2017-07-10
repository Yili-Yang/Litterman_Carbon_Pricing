% global 
% Phase1 is RBF with smoothing , no derivatives
% Phase2 Option1 is QN (with gradient)
% Phase 2 Option2 is more RBF 
%
% 
lb=-100; ub=100; m=2; varargin=1/40000;
gamma=1; deg=-1;
myfun=@rast; it=zeros(1,20);

f_qn=zeros(1,20);  fcount=zeros(1,20);   gcount=zeros(1,20);
f_qnl=zeros(1,20); fcount_l=zeros(1,20); gcount_l=zeros(1,20);
f_qn2=zeros(1,20);  feval2=zeros(1,20); f_f2=zeros(1,20);
fcount2=zeros(1,20); gcount2=zeros(1,20);

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
    xstar=2*(2*rand(dim,1)-1);
    useg=0;
    method='cubic';
    
    % Phase 1: RBF with lambda-Smooth
    %[f_cl,xcl,iter_cl,xbar_cl,fbar_cl]=RBFTRM_lsmooth(myfun,x,f,ind,xstar,Ls,method,deg,gamma,useg,varargin);
    
    [f_cl,xcl,iter_cl,xbar_cl,fbar_cl]=global_RBF_TRM(myfun,x,f,ind,xstar,Ls,method,deg,gamma,useg,varargin);
    % Phase 2: Quasi-Newton
   [f_qn2(i),~,fcount2(i),gcount2(i)]=quasi_newton(myfun,xcl,varargin);
    fcount2(i)=fcount2(i)+iter_cl+m;
    
    %Phase 2: continue using RBF
   ind2=find(fbar_cl==min(fbar_cl));
   [f_f2(i),~,feval2(i)]=RBFTRM(myfun,xbar_cl,fbar_cl,ind2,method,deg,gamma,useg,varargin );
   feval2(i)=feval2(i)+iter_cl+m;
    
    
    disp(i);
end



figure;
subplot(2,1,1);
plot(it,f_qn2,'d-',it,f_f2,'*-');
legend('f+ls and qn','f+ls and f');
title('2 Phases Comparison');
xlabel('Dim');
ylabel('Func Val');

subplot(2,1,2);
plot(it,fcount2,'d-',it,feval2,'*-',it,gcount2,'o-');
legend('f+ls and qn','f+ls and f','gcount of f+ls and qn');
xlabel('Dim');
ylabel('Num of Evals');