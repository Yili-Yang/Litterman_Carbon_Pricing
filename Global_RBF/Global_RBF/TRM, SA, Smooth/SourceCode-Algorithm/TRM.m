function [f,x,evalf,evalH]=TRM(myfun,x0,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Traditianl trust-region method, based on the algorithm from Professor
% Thomas. F. Coleman's course notes. Trust code from Mathwork.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tol=10^(-6);
iter=0; itbnd=500;
gamma_1=4;gamma_2=2;
tau_1=0.25;tau_2=0.75;
delta=norm(x0);
num=0;  % Count the number of ratio is negative.
[f_old,g,H]=feval(myfun,x0,varargin{:});
evalf=1;evalH=1;
x=x0;

while (norm(g)>tol && iter<itbnd)
%while (norm(g)>tol || posdef==0  && iter<itbnd)
    [s,~,~,~,~]=Trust(g,H,delta);
    qpval=g'*s+0.5*s'*H*s;
    [f_new,g_new,H_new]=feval(myfun,x+s,varargin{:});
    evalf=evalf+1;
    evalH=evalH+1;
    ratio=(f_new-f_old)/qpval;
    if (ratio<tau_1)
        delta=norm(s)/gamma_1;
    else if (ratio>tau_2 && abs(norm(s)-delta)<10^(-5))
            delta=gamma_2*delta;
        end
    end
    
    if (ratio>0)
        x=x+s;
        g=g_new;
        H=H_new;
        f_old=f_new;
    else
        num=num+1;
    end
    iter=iter+1;
end
f=f_old;
end