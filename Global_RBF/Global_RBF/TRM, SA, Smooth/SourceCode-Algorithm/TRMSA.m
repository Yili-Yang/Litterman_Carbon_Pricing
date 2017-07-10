function [f,x]=TRMSA(myfun,x0,Ts,L,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Trust region method combined with simulated anealing, uphill accept rule
% is exp(ratio/t)>rand. All parameters and other work based on the
% traditional trust region algorithm. 
%
% Phase 1 : for all temperature, we let the start point jump uphill or
% downhill using trust region, once the gradient is less than tol or we
% reach the max trials, we stop. If the point where we stop is different
% from any of the previous ones, we store it.
%
% Phase 2 : we use traditional trust region start from the points we get
% from phase 1 and pick the smallest f and its point to be the output.
%
% Trust code is from mathwork.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Input includes the temperature sequence and the max trials for each
% temperature. Output includes the final answer f and x 
%
% Delta_1=norm(x_0) for each temperature.
%
% The last several elements of the temperature sequence should be small
% enough to make it work.
%
% Set up parameters for trust-region method, parameters are based on
% professor Coleman's course notes, can be changed if needed.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tau_1=0.25; tau_2=0.75;
gamma_1=4; gamma_2=2;
tol=10^(-7);
n=length(x0);
f=myfun(x0,varargin{:});
f_best=zeros(length(Ts),1);
k=1;
x_thebest=zeros(length(Ts),n);
%%%%%%%%%%%%%%%%%%%%%%Phase 1%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i=1:length(Ts)
    iter=0;
    x=x0;
    t=Ts(i);
    [f_old,g,H]=feval(myfun,x,varargin{:});
    delta=norm(x);
    
     while ( norm(g)>tol && iter<L)
        [s,~,~,~,~]=Trust(g,H,delta);
        qpval=g'*s+0.5*s'*H*s;
        [f_new,g_new,H_new]=feval(myfun,x+s,varargin{:});
        ratio=(f_new-f_old)/qpval;
        if (ratio>tau_2 && abs(norm(s)-delta)<10^(-5))
            delta=gamma_2*delta;
        end
        
        if (ratio>0 || exp(ratio/t)>rand)
            x=x+s;
            g=g_new;
            H=H_new;
            f_old=f_new;
            if (ratio<tau_1 && ratio>0)
                delta=norm(s)/gamma_1;
            end
        else delta=norm(s)/gamma_1;
        end
        iter=iter+1;
    end
    
    x_best=x;
    f_best(i)=f_old;
    
    if i==1
        x_thebest(k,:)=x_best';
        k=k+1;
    end
    
    if i>1
        if (sum(abs(f_best(i)-f_best(1:i-1))<10^(-4))==0)
            x_thebest(k,:)=x_best';
            k=k+1;
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Phase 2%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i=1:(k-1)
    [fbar,xbar]=TRM(myfun,x_thebest(i,:)',varargin{:});
    if fbar<f
        f=fbar;
        x=xbar;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end
