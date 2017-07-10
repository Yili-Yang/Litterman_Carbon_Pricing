function [ f , x , fcount , gcount ] = quasi_newton_lsmooth( myfun , x0,...
    xstar, ls, varargin )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Quasi-Newton method (Algorithm 6.1) described in the book of chapter 6
% combined with lambda-smooth
% Smooth function is \bar{f}=f+lambda*||x-xstar||_2^2
%
% Input:
% myfun - function's name
% x0 - start point
% varargin - additional parameters for myfun
% xstar - the global optimum we guess
% ls - lambda sequence, last entry should be 0
%
% Output:
% f - final function value
% x - final point where we stop
% fcount - number of evaluation of function value
% gcount - number of evaluation of first gradient
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tol=1e-4;
itbnd=50;
n=length(x0);
x=x0;
fcount=0;
gcount=0;

if(isempty(ls))
    ls=[10*0.3.^(0:2),0];
end

if(ls(end)~=0)
    error('Last entry of lambda sequence is not 0!');
end

for i=1:length(ls)
    lambda=ls(i);
    [f,g]=feval(myfun,x,varargin{:});
    f=f+lambda*norm(x-xstar)^2;
    g=g+2*lambda*(x-xstar);
    fcount=fcount+1;
    gcount=gcount+1;
    iter=0;
    H=eye(n);
    
    while(norm(g)>tol && iter<itbnd && fcount<i*200)
        p=-H*g;
        if (g'*p>0)
            break
        end
        [alpha,fc,gc]=line_search_lsmooth(myfun,f,g,x,p,lambda,xstar,varargin{:});
        x=x+alpha*p;
        s=alpha*p;
        [f,g_new]=feval(myfun,x,varargin{:});
        f=f+lambda*norm(x-xstar)^2;
        g_new=g_new+2*lambda*(x-xstar);
        fcount=fcount+fc+1;
        gcount=gcount+gc+1;
        y=g_new-g;
        g=g_new;
        
        if (iter==0)
            H=y'*s/(y'*y)*eye(n);
        end
        
        iter=iter+1;
        
        % H=H-(H*y*y'*H)/(y'*H*y)+(s*s')/(y'*s);
        rho=1/(y'*s);
        H=(eye(n)-rho*s*y')*H*(eye(n)-rho*y*s')+rho*s*s';
        
    end
    
end

end
