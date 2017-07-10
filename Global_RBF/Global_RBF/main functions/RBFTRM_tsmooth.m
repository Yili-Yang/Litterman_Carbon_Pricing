function [ f , x , iter ] = RBFTRM_tsmooth ( myfun , xbar , fbar , ind ,...
    ds, method, deg, gamma, varargin )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Trust-region method with RBF model combined with trace-smooth
% RBF model: R(x)=sum_i lambda_i*phi(||x-x_i||)+p(x)
% Smooth function is: \bar{f}=f+1/6*delta*delta*trace(H)
%
% Input:
% myfun - original function
% xbar - the points we use to build the RBF model
% fbar - function value at xbar(i,:)
% ind - index of the starting point in xbar
% method - type of phi function for RBF model
% deg - degree of p(x) in RBF model
% gamma - parameter for phi function
% varargin - additional parameters for myfun
% ds - delta sequence for smoothing part, last entry should be 0
%
% Output:
% f - final function value
% x - the point where we stop
% iter - number of iterations
%
% Notice:
% We add a new stop criteria for trust-region method: norm(s)<tol2
% deg=1, p(x) is liner model. deg=0, p(x) is a constant. deg=-1, p(x)=0
% Theoritically, if deg=1, we need at least n+1 points to build the model,
% if deg=0 or -1, we can build the RBF model with any number of points we
% have.
% For each iteration in trust-region, we evaluate the original function
% value for the new point, and then update the RBF model
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tol=1e-6; tol2=1e-2;
iter=0; itbnd=50;
gamma_1=4; gamma_2=2;
tau_1=0.25; tau_2=0.75;
[m,~]=size(xbar);

if(isempty(ds))
    ds=[1*0.7.^(0:5),0];
end

if(ds(end)~=0)
    error('Last entry of lambda sequence is not 0!');
end

if (m~=length(fbar))
    error('size does not match!');
end

x=xbar(ind,:)';
f_mod=zeros(m,1);

for i=1:length(ds)
    
    del=ds(i);
    delta=norm(x);
    
    for j=1:length(fbar)
        [~,~,H]=RBFM(xbar,fbar,xbar(j,:),method,deg,gamma);
        f_mod(j)=fbar(j)+1/6*del*del*trace(H);
    end
    
    [f_old,g,H]=RBFM(xbar,f_mod,x',method,deg,gamma);
    [s,~,~,~,~]=Trust(g,H,delta);
    s=real(s);
    iter2=0;
    
    while (norm(g)>tol && iter2<itbnd && norm(s)>tol2)
        qpval=g'*s+0.5*s'*H*s;
        f_neworig=feval(myfun,x+s,varargin{:});
        xbar=[xbar;(x+s)'];
        fbar=[fbar;f_neworig];
        [~,~,H]=RBFM(xbar,fbar,(x+s)',method,deg,gamma);
        f_new=f_neworig+1/6*del*del*trace(H);
        f_mod=[f_mod;f_new];
        ratio=(f_new-f_old)/qpval;
        
        if (ratio<tau_1)
            delta=norm(s)/gamma_1;
        else if (ratio>tau_2 && abs(norm(s)-delta)<10^(-5))
                delta=gamma_2*delta;
            end
        end
        
        if (ratio>0)
            x=x+s;
            f_old=f_new;
        end
        
        [~,g,H]=RBFM(xbar,f_mod,x',method,deg,gamma);
        [s,~,~,~,~]=Trust(g,H,delta);
        s=real(s);
        iter2=iter2+1;
        
    end
    
    iter=iter+iter2;
    
end

f=min(fbar);
ind=find(fbar==f);
x=xbar(ind,:)';

end
