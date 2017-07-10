function [ alpha , fcount , gcount ] = line_search ( myfun , f , g, x , p, varargin )
% Backtracking line search algorithm for quasi-newton method. Algorithm 3.1
% in the book.

alpha=1;
rho=0.5;
c=1e-4;
fcount=0;
gcount=0;
fval=feval(myfun,x+alpha*p,varargin{:});
fcount=fcount+1;

while (fval > f+c*alpha*g'*p && alpha>1e-5)
    alpha=alpha*rho;
    fval=feval(myfun,x+alpha*p,varargin{:});
    fcount=fcount+1;
end

end