% Compare f+g+RBF Hessian and Quasi-Newton method

lb=-50; ub=50; m=2; varargin=1/40000; gamma=2; deg=0;
myfun=@rast; it=zeros(1,20);
f_cubicg=zeros(1,20);iter_cubicg=zeros(1,20);
f_mqg=zeros(1,20); iter_mqg=zeros(1,20);
f_qn=zeros(1,20); fcount=zeros(1,20);
gcount=zeros(1,20);

for i=1:20
    it(i)=i;
    dim=i;
    x=(-lb+ub).*(2*rand(m,dim)-1)/2+(lb+ub)/2;
    f=zeros(m,1);
    for j=1:m
        f(j)=myfun(x(j,:),varargin);
    end
    ind=find(f==min(f));
    useg=1;
    method='cubic';
    [f_cubicg(i),~,iter_cubicg(i)]=RBFTRM(myfun,x,f,ind,method,deg,gamma,useg,varargin);
    method='multiquadric1';
    [f_mqg(i),~,iter_mqg(i)]=RBFTRM(myfun,x,f,ind,method,deg,gamma,useg,varargin);
    iter_cubicg(i)=iter_cubicg(i)+m;
    iter_mqg(i)=iter_mqg(i)+m;
    [f_qn(i),~,fcount(i),gcount(i)]=quasi_newton(myfun,x(ind,:)',varargin);
    disp(i);
end

figure;
plot(it,f_cubicg,'d-',it,f_mqg,'s-',it,f_qn,'o-');
legend('Cubic-g','Multiquadric-g','Quasi-Newton');
title('Compare f+g+RBF Hessian and Q-N method');
xlabel('Dim');
ylabel('Final Func Val')

figure;
plot(it,iter_cubicg,'d-',it,iter_mqg,'s-',it,fcount,'o-',it,gcount,'+-');
legend('Cubic-g','Multiquadric-g','fcount of Q-N','gcount of Q-N');
title('Compare f+g+RBF Hessian and Q-N method');
xlabel('Dim');
ylabel('Iter')
