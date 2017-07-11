function [ f , g , H ] = RBFM ( xbar , fbar , x , method , deg , gamma )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%               CAYUGA RESEARCH, October 2015
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Computes the value of RBF model
% and it's first and second gradient at point x.
%
% INPUT:
% xbar - the points we have to build the RBF model. A matrix
% fbar - the true function value at points  xbar
% x - the point where we want to compute the f, g, and H
% method - the choice for RBF model's phi function
% deg - the degree of p(x), should be 1 (linear), 0 (constant), or -1({0})
% gamma - parameter for the phi function
%
% OUTPUT:
% f - RBF model function value at x
% g - first gradient value of RBF at x
% H - second gradient value of RBF at x
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[m,n]=size(xbar);
phi=zeros(m);
for i=1:m
    for j=i:m
%         if iscell(xbar(i,:))
%             xbar(i,:)=cell2mat(xbar(i,:));
%         end
%         if iscell(xbar(j,:))
%             xbar(j,:)=cell2mat(xbar(j,:));
%         end
        if iscell(xbar(i,:))
            temp1 = cellfun(@minus,xbar(i,:),xbar(j,:),'UniformOutput',false);
            temp2 = cellfun(@norm,temp1,'UniformOutput',false);
            phi(i,j)=phifunc(temp2, method, gamma);
        else
            phi(i,j)=phifunc(norm(xbar(i,:)-xbar(j,:)),method,gamma);
        end
        phi(j,i)=phi(i,j);
    end
end

if(deg==1)
    P=[xbar,ones(m,1)];
    M=[phi,P;P',zeros(n+1)];
    F=[fbar;zeros(n+1,1)];
    coeff=M\F;
    val=0;
    g=zeros(n,1);
    H=zeros(n);
    
    for l=1:m
        z=(x-xbar(l,:))';
        if(norm(z)>1e-5)
            [fstar,gstar,Hstar]=phifunc(norm(z),method,gamma);
            val=val+coeff(l)*fstar;
            g=g+coeff(l)*gstar*z/norm(z);
            H=H+coeff(l)*(gstar/norm(z)*eye(n)+(Hstar-gstar/...
                norm(z))*z*z'/norm(z)^2);
        else
            fstar=phifunc(0,method,gamma);
            val=val+coeff(l)*fstar;
            phiprime=phiprimefunc(method,gamma);
            H=H+coeff(l)*phiprime*eye(n);
        end
    end
    f=val+coeff(m+1:m+n)'*x'+coeff(m+n+1);
    g=g+coeff(m+1:m+n);
end

if(deg==0)
    P=ones(m,1);
    M=[phi,P;P',0];
    F=[fbar;0];
    coeff=M\F;
    val=0;
    g=zeros(n,1);
    H=zeros(n);
    
    for l=1:m
        z=(x-xbar(l,:))';
        if(norm(z)>1e-5)
            [fstar,gstar,Hstar]=phifunc(norm(z),method,gamma);
            val=val+coeff(l)*fstar;
            g=g+coeff(l)*gstar*z/norm(z);
            H=H+coeff(l)*(gstar/norm(z)*eye(n)+(Hstar-gstar/...
                norm(z))*z*z'/norm(z)^2);
        else
            fstar=phifunc(0,method,gamma);
            val=val+coeff(l)*fstar;
            phiprime=phiprimefunc(method,gamma);
            H=H+coeff(l)*phiprime*eye(n);
        end
    end
    disp(H)
    f=val+coeff(m+1);
end

if(deg==-1)
    coeff=phi\fbar;
    val=0;
    g=zeros(n,1);
    H=zeros(n);
    
    for l=1:m
        z=(x-xbar(l,:))';
        if(norm(z)>1e-5)
            [fstar,gstar,Hstar]=phifunc(norm(z),method,gamma);
            val=val+coeff(l)*fstar;
            g=g+coeff(l)*gstar*z/norm(z);
            H=H+coeff(l)*(gstar/norm(z)*eye(n)+(Hstar-gstar/...
                norm(z))*z*z'/norm(z)^2);
        else
            fstar=phifunc(0,method,gamma);
            val=val+coeff(l)*fstar;
            phiprime=phiprimefunc(method,gamma);
            H=H+coeff(l)*phiprime*eye(n);
        end
    end
    f=val;
end
