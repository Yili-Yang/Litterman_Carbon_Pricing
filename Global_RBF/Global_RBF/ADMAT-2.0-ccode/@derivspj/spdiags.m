function s=spdiags(V,crange,m,n)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global globp;

V=derivspj(V);
m=derivspj(m);
n=derivspj(n);
s.val=spdiags(V.val,crange,m.val,n.val);
s.derivspj=cell(m.val,1);

for i=1:globp
    s.derivspj{i}=sparse(m.val,n.val);
end

for j=1:globp
    X=[];
    for i=1:m.val
        X(i,:)=V.derivspj{i}(j,:);
    end
    Y=spdiags(X,crange,m.val,n.val);
    for i=1:n.val
        s.derivspj{j}(:,i)=Y(:,i);
    end
end

s=class(s,'derivspj');
