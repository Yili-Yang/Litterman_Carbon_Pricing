function [colors,order]=dirhess(H)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

[n,n]=size(H);
H=H+speye(n);
H=spones(H);
deg=sum(H);
colors=zeros(n,1);
order=zeros(n,1);

num=n;
k=1;
count=1;
count2=1;
P=H*H;

while num > 0
    [v,ind]=sort(deg);
    wk=[];
    for j=n:-1:count2
        s=full(sum(P(wk,ind(j))));
        if isempty(s)
            s=0; 
        end
        if (s==0)
            wk1=[wk ind(j)];
            wk = wk1;
            order(count)=ind(j);
            count=count+1;
        end
    end
    l=length(wk);
    count2=count2+l;
    colors(wk)=k*ones(l,1);
    k=k+1;
    num=num-l;
    H(wk,:)=zeros(l,n);
    H(:,wk)=zeros(n,l);
    P=H*H;
    deg=sum(H);
    deg(wk)=zeros(l,1);
end
