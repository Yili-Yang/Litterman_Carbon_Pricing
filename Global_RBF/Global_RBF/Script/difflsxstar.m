% Test if different lambda-sequences and different number of x_* has an
% effect for the result.

lb=-100; ub=100; m=2; varargin=1/40000; gamma=1; deg=-1;
myfun=@rast; it=zeros(1,20);

f_qn1=zeros(1,20);  fcount1=zeros(1,20);   gcount1=zeros(1,20);
f_qn2=zeros(1,20);  fcount2=zeros(1,20);   gcount2=zeros(1,20);

f_qn4=zeros(1,20);  fcount4=zeros(1,20);   gcount4=zeros(1,20);
f_qn5=zeros(1,20);  fcount5=zeros(1,20);   gcount5=zeros(1,20);

for i=1:20
    it(i)=i;
    dim=i;
    x=(-lb+ub).*(2*rand(m,dim)-1)/2+(lb+ub)/2;
    f=zeros(m,1);
    
    for j=1:m
        f(j)=myfun(x(j,:),varargin);
    end
    
    ind=find(f==min(f));
    Ls1=[10*0.3.^(0:2),0];
    Ls2=[10*0.8.^(0:15),0];
    
    xstar=10*(2*rand(dim,5)-1);
    
    useg=0;
    method='cubic';
    [f_cl1,xcl1,iter_cl1,xbar,fbar]=RBFTRM_lsmooth(myfun,x,f,ind,xstar(:,1),Ls1,method,deg,gamma,useg,varargin);
    [f_qn1(i),~,fcount1(i),gcount1(i)]=quasi_newton(myfun,xcl1,varargin);
    fcount1(i)=fcount1(i)+iter_cl1+m;
    
    [f_cl2,xcl2,iter_cl2,~,~]=RBFTRM_lsmooth(myfun,x,f,ind,xstar(:,1),Ls2,method,deg,gamma,useg,varargin);
    [f_qn2(i),~,fcount2(i),gcount2(i)]=quasi_newton(myfun,xcl2,varargin);
    fcount2(i)=fcount2(i)+iter_cl2+m;

    ind=(find(fbar==f_cl1));
    [f_cl4,xcl4,iter_cl4,xbar,fbar]=RBFTRM_lsmooth(myfun,xbar,fbar,ind,xstar(:,2),Ls1,method,deg,gamma,useg,varargin);
    ind=(find(fbar==f_cl4));
    [f_cl5,xcl5,iter_cl5,xbar,fbar]=RBFTRM_lsmooth(myfun,xbar,fbar,ind,xstar(:,3),Ls1,method,deg,gamma,useg,varargin);
    ind=(find(fbar==f_cl5));
    [f_cl6,xcl6,iter_cl6,xbar,fbar]=RBFTRM_lsmooth(myfun,xbar,fbar,ind,xstar(:,4),Ls1,method,deg,gamma,useg,varargin);
    ind=(find(fbar==f_cl6));
    [f_cl7,xcl7,iter_cl7,xbar,fbar]=RBFTRM_lsmooth(myfun,xbar,fbar,ind,xstar(:,5),Ls1,method,deg,gamma,useg,varargin);
    [f_qn4(i),~,fcount4(i),gcount4(i)]=quasi_newton(myfun,xcl7,varargin);
    fcount4(i)=fcount4(i)+iter_cl1+iter_cl4+iter_cl5+iter_cl6+iter_cl7+m;
%     
%     ind=(find(fbar==f_cl7));
%     [f_cl8,xcl8,iter_cl8,xbar,fbar]=RBFTRM_lsmooth(myfun,xbar,fbar,ind,xstar(:,6),Ls1,method,deg,gamma,useg,varargin);
%     ind=(find(fbar==f_cl8));
%     [f_cl9,xcl9,iter_cl9,xbar,fbar]=RBFTRM_lsmooth(myfun,xbar,fbar,ind,xstar(:,7),Ls1,method,deg,gamma,useg,varargin);
%     ind=(find(fbar==f_cl9));
%     [f_cl10,xcl10,iter_cl10,xbar,fbar]=RBFTRM_lsmooth(myfun,xbar,fbar,ind,xstar(:,8),Ls1,method,deg,gamma,useg,varargin);
%     ind=(find(fbar==f_cl10));
%     [f_cl11,xcl11,iter_cl11,xbar,fbar]=RBFTRM_lsmooth(myfun,xbar,fbar,ind,xstar(:,9),Ls1,method,deg,gamma,useg,varargin);
%     ind=(find(fbar==f_cl11));
%     [f_cl12,xcl12,iter_cl12,xbar,fbar]=RBFTRM_lsmooth(myfun,xbar,fbar,ind,xstar(:,10),Ls1,method,deg,gamma,useg,varargin);
%     
%     [f_qn5(i),~,fcount5(i),gcount5(i)]=quasi_newton(myfun,xcl12,varargin);
%     fcount5(i)=fcount5(i)+fcount4(i)+iter_cl8+iter_cl9+iter_cl10+iter_cl11+iter_cl12;
%     
    disp(i);
end

figure;
subplot(2,1,1);
plot(it,f_qn1,'d-',it,f_qn2,'*-');
legend('4 entries','17 entries');
title('Different \lambda Sequence');
xlabel('Dim');
ylabel('Func Val');

subplot(2,1,2);
plot(it,fcount1,'d-',it,fcount2,'*-');
legend('4 entries','17 entries');
xlabel('Dim');
ylabel('Num of Func Evals');

figure;
subplot(2,1,1);
plot(it,f_qn1,'d-',it,f_qn4,'*-');
legend('1 x_*','5 x_*');
title('Different Number of x_*');
xlabel('Dim');
ylabel('Func Val');

subplot(2,1,2);
plot(it,fcount1,'d-',it,fcount4,'*-');
legend('1 x_*','5 x_*');
xlabel('Dim');
ylabel('Num of Func Evals');
