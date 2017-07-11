function [ f , x , iter , xxbar , ffbar ] = global_RBF_TRM ( myfun , xbar...
    , fbar , ind , xstar, ls, method, deg, gamma, useg, varargin )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%            CAYUGA RESEARCH, October 2015
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% global_RBF_TRM: (First phase of) a global optimization method based on
% Radial Basis Function approximations to the objective function
% to be minimized, along with a smoothing term to enhance "global"
% minimization.  Trust Region Methodology is used to solve each subproblem.
%
% The objective function is assumed to be continuous
% and only function evaluations are strictly required  in this phase.
% It is possible to use gradient terms of the objective function,
% but it isd not required.
%
% A trust-region method is used ON THE MODELLING FUNCTION
% (not the original function) to decrease the model.
%
% If the user wishes to use the true gradient in the formulation
% of the trust region problem it can be supplied if useg = 1 and the
% gradient function, or AD is invoked.
% Otherwise the gradient of the smoothed RBF function
% is used along with the hessian of the RBF function
% (both are analytically available)
%
% The RBF model: R(x)=sum_i lambda_i*phi(||x-x_i||)+p(x)
% And the smoothing term model: \bar{f}=f+lambda*||x-xstar||_2^2
% where xstar is a guess for the global minimizer. This guess
% helps with the scaling -- a guess of all zeros can be useful
% in the absence of other information.
%
% INPUT:
% myfun - original function. Can be a handle to the function to be minimized.
%
% xbar - the points we use to build the RBF model. xbar is mxn where
% m is the number of points used for the model, and n is the dimension.
%
% fbar - function value at xbar(~,:)
%
% ind - index of the starting point in xbar. that is xbar(ind,:) is
% the starting point for the optimzation procedure.
%
% method - type of phi function for RBF model. method is a string variable.
% current choices are 'cubic', 'multiquadric1', 'multiquadric2', 'inmultiquadric',
% 'Gaussian'. See function 'phifunc' for more detail
%
% deg - degree of p(x) in RBF model.
% if deg = -1, p(x) = 0, if deg = 0 a constant, p(x) = a,  is used
% if deg = 1 a linear fcn , p(x) = b'x+a, is used. .
% See function RBFM for more details.
%
%
% gamma - parameter for phi function. default gamma = 1;
%
% varargin - additional parameters for myfun
%
% useg - useg = 1 indicates the gradient will be computed at eaxh point
%        and used in the trust region problem
% xstar - initial guessestimate of the global optiimum
%
% ls - lambda sequence for smoothing part, last entry should be 0.
% A default sequnce is suppplied below
%
% OUTPUT:
% f - final function value at computed optimum
%
% x - the computed optimum
%
% iter - number of iterations
%
% xxbar: an array of the points (n-vectors) at which the objective function
% was evaluated
%
% ffbar the vector ofobjective function values at all points in xxbar
%
% Note:
% We add a new stopping  criteria for trust-region method: norm(s)<tol2
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
[m,n]=size(xbar);

if(isempty(ls))
    ls=[10*0.3.^(0:2),0];
end

if(ls(end)~=0)
    error('Last entry of lambda sequence is not 0!');
end
if (m~=length(fbar))
    error('size does not match!');
end

x=xbar(ind,:)';
if (useg==1)
    % user supply first gradient
    
    for i=1:length(ls)
        lambda=ls(i);
        [~,~,H]=RBFM(xbar,fbar,x',method,deg,gamma);
        H=H+2*lambda*eye(n);
        [f1,g]=feval(myfun,x,varargin{:});
        f_old=f1+lambda*norm(x-xstar)^2;
        g=g+2*lambda*(x-xstar);
        delta=norm(x);
        [s,~,~,~,~]=Trust(g,H,delta);
        s=real(s);
        iter2=0;
        
        while (norm(g)>tol && iter2<itbnd && norm(s)>tol2)
            qpval=g'*s+0.5*s'*H*s;
            [f_neworig,g_new]=feval(myfun,x+s,varargin{:});
            f_new=f_neworig+lambda*norm(x+s-xstar)^2;
            g_new=g_new+2*lambda*(x-xstar);
            xbar=[xbar;(x+s)'];
            fbar=[fbar;f_neworig];
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
            end
            
            [~,~,H]=RBFM(xbar,fbar,x',method,deg,gamma);
            H=H+2*lambda*eye(n);
            [s,~,~,~,~]=Trust(g,H,delta);
            s=real(s);
            iter2=iter2+1;
        end
        
        iter=iter+iter2;
        
    end
    
    f=min(fbar);
    ind=find(fbar==f);
    x=xbar(ind,:)';
    
else
    % user supply f only
    
    for i=1:length(ls)
        lambda=ls(i);
        delta=norm(x);
        [f1,g,H]=RBFM(xbar,fbar,x',method,deg,gamma);
        x_size = size(x);
        xs_size = size(xstar);
        f_old=f1+lambda*norm(x-xstar)^2;
        H=H+2*lambda*eye(n);
        g=g+2*lambda*(x-xstar);
        [s,~,~,~,~]=Trust(g,H,delta);
        s=real(s);
        iter2=0;
        count = 0;
        while (norm(g)>tol && iter2<itbnd && norm(s)>tol2)
            disp(count)
            qpval=g'*s+0.5*s'*H*s;
            disp(x+s)
            f_neworig=feval(myfun,(x+s)',varargin{:});
            disp(f_neworig)
            f_new=f_neworig+lambda*norm(x+s-xstar)^2;
            xbar=[xbar;(x+s)'];
            fbar=[fbar;f_neworig];
            %             f_size = size(f_new)
            %             q_size = size(qpval)
            %             qpval
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
            
            [~,g,H]=RBFM(xbar,fbar,x',method,deg,gamma);
            g=g+2*lambda*(x-xstar);
            H=H+2*lambda*eye(n);
            [s,~,~,~,~]=Trust(g,H,delta);
            s=real(s);
            iter2=iter2+1;
            count = count + 1;
        end
        
        iter=iter+iter2;
        
    end
    
    f=min(fbar);
    ind=find(fbar==f);
    x=xbar(ind,:)';
    
end
xxbar = xbar;
ffbar = fbar;
end
