function [ f , x , evalf , evalH ] = TRMLaSmooth ( myfun , x0 , xstar,...
     lambda , varargin )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Trust-Region method with lambda-Smooth technique. Instead of using
% original function, we use a smooth function fbar=f+lambda||x-x_*||_2^2 to
% optimize the problem. lambda sequence is defiend by user and the last
% entry should be 0 in order to guarantee we optimize the original function
% at last. There are 2 phases:
%
% Phase 1 : for all lambda in the sequence, we use tradional trust-region 
% method with start point and modified function fbar to minimize the
% problem. If the point where we stop is different from any of the previous
% ones, we store it.
%
% Phase 2 : we use traditional trust region start from the points we get
% from phase 1 and pick the smallest f and its point to be the output.
%
% TRM parameters are set as mentioned on Prof. Coleman's course note. We
% use modified gradient and Hessian matrix for subproblem. 
%
% Input arguments:
% myfun - function name
% x0 - starting point
% xstar - global optimum we guess
% lambda - lambda sequence, last entry must be 0
% varargin - additional arguments to function "fun"
%
% Returns:
% final function value and its point and the number of evaluations of
% function value and Hessian matrix
%
% Trust code is from mathwork
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tau_1=0.25;tau_2=0.75;
gamma_1=4;gamma_2=2;
tol=10^(-6);
evalf=1;evalH=0;
n=length(x0);
f=myfun(x0,varargin{:});
f_best=zeros(length(lambda),1);
k=1; ind=1;
x_thebest=zeros(length(lambda),n);
itbnd=500;

if(lambda(end)~=0)
    error('Last entry of lambda sequence must be 0!')
end

%%%%%%%%%%%%%%%%%%%%%%Phase 1%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for j=1:length(lambda)
    x=x0;
    Lambda=lambda(j);
    iter=0;
    delta=norm(x);
    [fold_orig,g_orig,H_orig]=feval(myfun,x,varargin{:});
    evalf=evalf+1;
    evalH=evalH+1;
    g=g_orig+2*Lambda*(x-xstar);
    H=H_orig+2*Lambda*diag(ones(1,n));
    fold=fold_orig+Lambda*norm(x-xstar)^2;
    
    while ( norm(g)>tol && iter<itbnd)
        [s,~,~,~,~]=Trust(g,H,delta);
        qpval=g'*s+0.5*s'*H*s;
        [fnew_orig,g_new,H_new]=feval(myfun,x+s,varargin{:});
        evalf=evalf+1;
        evalH=evalH+1;
        fnew=fnew_orig+Lambda*norm(x+s-xstar)^2;
        ratio=(fnew-fold)/qpval;
        
        if (ratio<tau_1)
            delta=norm(s)/gamma_1;
        else if (ratio>tau_2 && abs(norm(s)-delta)<10^(-5))
                delta=gamma_2*delta;
            end
        end
        
        if (ratio>0)
            x=x+s;
            g=g_new+2*Lambda*(x-xstar);
            H=H_new+2*Lambda*diag(ones(1,n));
            fold=fnew;
        end
        iter=iter+1;
    end
    
    x_best=x;
    f_best(ind)=fold;
    ind=ind+1;
    
    if k==1
        x_thebest(k,:)=x_best';
        k=k+1;
    end
    
    if ind>2
        if (sum(abs(f_best(ind-1)-f_best(1:ind-2))<10^(-4))==0)
            x_thebest(k,:)=x_best';
            k=k+1;
        end
    end
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Phase 2%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:(k-1)
    [fbar,xbar,evalf_bar,evalH_bar]=TRM(myfun,x_thebest(i,:)',varargin{:});
    evalf=evalf+evalf_bar;
    evalH=evalH+evalH_bar;
    if fbar<f
        f=fbar;
        x=xbar;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end
