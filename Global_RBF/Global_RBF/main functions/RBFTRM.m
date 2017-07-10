function [ f , x , iter ] = RBFTRM ( myfun , xbar , fbar , ind , method,...
    deg, gamma, useg, varargin )
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                  CAYUGA RESEARCH, October, 2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Trust-region method with RBF model.
% RBF model: R(x)=sum_i lambda_i*phi(||x-x_i||)+p(x)
%
% Input:
% myfun - original function
% xbar - the points we use to build the RBF model
% fbar - function value at xbar(~,:)
% ind - index of the starting point in xbar
% method - type of phi function for RBF model
% deg - degree of p(x) in RBF model
% gamma - parameter for phi function
% varargin - additional parameters for myfun
% useg - whether we use the user supplied gradient
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
delta=norm(xbar(ind,:));
[m,~]=size(xbar);
num=0; %deltamin=0.1;

if (m~=length(fbar))
    error('size does not match!');
end

if (useg==1)
    % user supply the gradient
    
    f_old=fbar(ind);
    [~,~,H]=RBFM(xbar,fbar,xbar(ind,:),method,deg,gamma);
    x=xbar(ind,:)';
    [~,g]=feval(myfun,x,varargin{:});
    [s,~,~,~,~]=Trust(g,H,delta);
    s=real(s);
    
    while (norm(g)>tol && iter<itbnd && norm(s)>tol2)
        qpval=g'*s+0.5*s'*H*s;
        [f_new,g_new]=feval(myfun,x+s,varargin{:});
        xbar=[xbar;(x+s)'];
        fbar=[fbar;f_new];
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
            g=g_new;
        else
            num=num+1;
        end
        
        [~,~,H]=RBFM(xbar,fbar,x',method,deg,gamma);
        [s,~,~,~,~]=Trust(g,H,delta);
        s=real(s);
        iter=iter+1;
        
    end
    
    f=f_old;
    
else
    % user supply f only
    
    f_old=fbar(ind);
    [~,g,H]=RBFM(xbar,fbar,xbar(ind,:),method,deg,gamma);
    x=xbar(ind,:)';
    [s,~,~,~,~]=Trust(g,H,delta);
    s=real(s);
    
    while (norm(g)>tol && iter<itbnd && norm(s)>tol2)
        qpval=g'*s+0.5*s'*H*s;
        f_new=feval(myfun,x+s,varargin{:});
        xbar=[xbar;(x+s)'];
        fbar=[fbar;f_new];
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
        else
            num=num+1;
        end
        
        [~,g,H]=RBFM(xbar,fbar,x',method,deg,gamma);
        [s,~,~,~,~]=Trust(g,H,delta);
        s=real(s);
        iter=iter+1;
        
    end
    
    f=f_old;
    
end

end