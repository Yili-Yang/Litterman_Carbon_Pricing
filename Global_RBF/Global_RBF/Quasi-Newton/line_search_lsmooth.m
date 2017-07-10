function [ alpha , fcount , gcount ] = line_search_lsmooth(myfun,f,g,x,p,lambda,xstar,varargin)
% Backtracking line search algorithm for quasi-newton with lambda-Smooth
% method. 

alpha=1;
rho=0.5;
c=1e-4;
fcount=0;
gcount=0;
fval=feval(myfun,x+alpha*p,varargin{:});
fcount=fcount+1;
fval=fval+lambda*norm(x+alpha*p-xstar)^2;
while (fval > f+c*alpha*g'*p && alpha>1e-3 )
    alpha=alpha*rho;
    fval=feval(myfun,x+alpha*p,varargin{:});
    fval=fval+lambda*norm(x+alpha*p-xstar)^2;
    fcount=fcount+1;
end

end