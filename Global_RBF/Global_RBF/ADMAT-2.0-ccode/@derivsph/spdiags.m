function s=spdiags(V,crange,m,n)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global globp
V=derivsph(V);
m=derivsph(m);
n=derivsph(n);
s=spdiags(V.val,crange,getval(m),getval(n));

s=derivsph(s);

for j=1:globp
    for j2=1:globp
        X=[];
        for i=1:getval(m)
            for k=1:size(V.derivsph,2)
                X(i,k)=V.derivsph{i,k}(j,j2);
            end
        end
        Y=spdiags(X,crange,getval(m),getval(n));
        for i=1:getval(m)
            for k=1:size(V.derivsph,2)
                s.derivsph{i,k}(j,j2)=Y(i,k);
            end
        end
    end
end

