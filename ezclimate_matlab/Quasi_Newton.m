function [ f , x , fcount , gcount ] = Quasi_Newton( myfun , x0)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%           CAYUGA RESEARCH, Oct 2015
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Quasi-Newton method (Algorithm 6.1) described in the book of chapter 6.
%
% Input:
% myfun - function's name
% x0 - start point
% varargin - additional parameters for myfun
%
% Output:
% f - final function value
% x - final point where we stop
% fcount - number of evaluation of function value
% gcount - number of evaluation for first gradient of f
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tol=1e-4;
itbnd=500*1e20;
n=length(x0);
H=eye(n);
x=x0;
[f,g]=feval(myfun,x);
fcount=1;
gcount=1;
iter=0;

while(norm(g)>tol && iter<itbnd && fcount<1e3)
    p=-H*g;
    if (g'*p>0)
        H=eye(n);
        p=-H*g;
    end
    [alpha,fc,gc]=line_search(myfun,f,g,x,p);
    x=x+alpha*p;
    s=alpha*p;
    [f,g_new]=feval(myfun,x);

    fcount=fcount+fc+1;
    gcount=gcount+gc+1;
    y=g_new-g;
    g=g_new;
    
    if (iter==0)
        H=y'*s/(y'*y)*eye(n);
    end
    
    iter=iter+1;
    rho=1/(y'*s);
    %H=H-(H*y*y'*H)/(y'*H*y)+(s*s')/(y'*s);
    H=(eye(n)-rho*s*y')*H*(eye(n)-rho*y*s')+rho*s*s';
end

end
