function [f,x]=TRMSATrSmooth(myfun,x0,Ts,L,delta,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Trust-Region method with simulated annealing and Trace-Smooth technique. 
% Instead of using original function, we use a smooth function 
% fbar=f+1/6*delta^2*Trace(H) to optimize the problem. Delta sequence is 
% defiend by user and the last entry should be 0 in order to guarantee we 
% optimize the original function at last. 
% Uphill accept rule is exp(ratio/t)>rand. All parameters and other work 
% based on the traditional trust region algorithm. There are 2 phases:
%
% Phase 1 : for all Delta in the sequence , we run through all temperature, 
% we let the start point jump uphill or downhill using trust region, once 
% the gradient is less than tol or we reach the max trials, we stop. If the
% point where we stop is different from any of the previous ones, we store 
% it.
%
% Phase 2 : we use traditional trust region start from the points we get
% from phase 1 and pick the smallest f and its point to be the output.
%
% Trust code is from mathwork.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Input arguments: 
% myfun - function name
% x0 - starting point
% Ts(1:end) - temperatures from hottest to coldest (Ts(end) cannot be 0)
% L - number of trials at one temperature
% delta(1:end) - Delta-sequence, the last entry must be 0
% varargin - additional arguments to function "fun"
%
% Returns:
% Final answer f and x 
%
% Delta_1=norm(x_0) for each temperature.
%
% The last several elements of the temperature sequence should be small
% enough to make it work.
%
% TRM parameters are based on professor Coleman's course notes, can be 
% changed if needed
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(Ts(1)<0)
    error('Wrong Temperature Sequence!');
end
if(delta(end)~=0)
    error('Last entry of delta sequence should be 0!')
end
tau_1=0.25; tau_2=0.75;
gamma_1=4; gamma_2=2;
tol=10^(-7);
n=length(x0);
f=myfun(x0,varargin{:});
f_best=zeros(length(Ts),1);
k=1; ind=1;
x_thebest=zeros(length(Ts),n);

%%%%%%%%%%%%%%%%%%%%%%Phase 1%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for j=1:length(delta)
    Delta=delta(j);

    for i=1:length(Ts)
        iter=0;
        x=x0;
        t=Ts(i);
        delta=norm(x);
        [fold_orig,g,H]=feval(myfun,x,varargin{:});
        fold=fold_orig+1/6*Delta*Delta*trace(H);
        
        while ( norm(g)>tol && iter<L)
            [s,~,~,~,~]=Trust(g,H,delta);
            qpval=g'*s+0.5*s'*H*s;
            [fnew_orig,g_new,H_new]=feval(myfun,x+s,varargin{:});
            fnew=fnew_orig+1/6*Delta*Delta*trace(H_new);
            ratio=(fnew-fold)/qpval;
            
            if (ratio>tau_2 && abs(norm(s)-delta)<10^(-4))
                delta=gamma_2*delta;
            end
            
            if (ratio>0 || exp(ratio/t)>rand)
                x=x+s;
                g=g_new;
                H=H_new;
                fold=fnew;
                if (ratio<tau_1 && ratio>0)
                    delta=norm(s)/gamma_1;
                end
            else delta=norm(s)/gamma_1;
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
            if (sum(abs(f_best(i)-f_best(1:i-1))<10^(-4))==0)
                x_thebest(k,:)=x_best';
                k=k+1;
            end
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
