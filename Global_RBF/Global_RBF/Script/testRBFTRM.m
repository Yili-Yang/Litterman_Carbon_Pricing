% Compare RBF method (f only) with f+g+RBF Hessian method (using cubic and
% multiquadric model)

lb=-200; ub=200; m=2; varargin=1/40000; gamma=0.5; deg=-1;
myfun=@rast; it=zeros(1,20);
f_cubic=zeros(1,20); iter_cubic=zeros(1,20);
f_cubicg=zeros(1,20);iter_cubicg=zeros(1,20);
f_mqg=zeros(1,20); iter_mqg=zeros(1,20);
f_mq=zeros(1,20); iter_mq=zeros(1,20);

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
    method='multiquadric2';
    [f_mqg(i),~,iter_mqg(i)]=RBFTRM(myfun,x,f,ind,method,deg,gamma,useg,varargin);
    
    useg=0;
    method='cubic';
    [f_cubic(i),~,iter_cubic(i)]=RBFTRM(myfun,x,f,ind,method,deg,gamma,useg,varargin); 
    method='multiquadric2';
    [f_mq(i),~,iter_mq(i)]=RBFTRM(myfun,x,f,ind,method,deg,gamma,useg,varargin);
    disp(i);
end

figure;
plot(it,f_cubic,'o-',it,f_mq,'+-',it,f_cubicg,'d-',it,f_mqg,'s-');
legend('Cubic','Multyquadric','Cubic-g','Multiquadric-g');
xlabel('Dim');
title('Final Func Value');

figure;
plot(it,iter_cubic,'o-',it,iter_mq,'+-',it,iter_cubicg,'d-',it,iter_mqg,'s-');
legend('Cubic','Multyquadric','Cubic-g','Multiquadric-g');
xlabel('Dim');
title('Num of Iter');