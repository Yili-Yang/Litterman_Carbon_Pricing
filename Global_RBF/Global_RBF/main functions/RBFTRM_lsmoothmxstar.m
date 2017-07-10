function [ f , x , iter  ] = RBFTRM_lsmoothmxstar ( myfun , xbar...
    , fbar , ind , xstar, ls, method, deg, gamma, useg, style, varargin )

% f only with lambda-Smooth with multiple xstars

iter=0;
[~,n]=size(xstar);

if(style==1)
    % Continue using the information we have. Cannot parallel computing
    for i=1:n
        [fcl,~,iter_cl,xbar,fbar]=RBFTRM_lsmooth(myfun,xbar,fbar,ind,xstar(:,i),ls,method,deg,gamma,useg,varargin);
        iter=iter+iter_cl;
        ind=(find(fbar==fcl));
    end
    f=min(fbar);
    ind=find(fbar==f);
    x=xbar(ind,:);
else
    % Separately compute the results. Can parallel computing
    fcl=zeros(n,1);
    xcl=zeros(m,n);
    for i=1:n
        [fcl(i),xcl(:,i),iter_cl]=RBFTRM_lsmooth(myfun,xbar,fbar,ind,xstar(:,i),ls,method,deg,gamma,useg,varargin);
        iter=iter+iter_cl;
    end
    f=min(fcl);
    ind=find(fbar==f);
    x=xcl(:,ind);
end

end