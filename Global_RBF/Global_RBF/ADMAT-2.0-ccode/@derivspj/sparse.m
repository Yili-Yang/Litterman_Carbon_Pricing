function y=sparse(i,j,s,m,n)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global globp;

i=getval(i);
if nargin == 1
    y=sparse(i);
    y=derivspj(y);
elseif nargin == 2
    j=getval(j);
    y=sparse(i,j);
    y=derivspj(y);
elseif nargin == 3
    j=getval(j);
    s = derivspj(s);
    y.val=sparse(i,j,getval(s));
    for k = 1:globp
        y.derivspj{k}=sparse(i,j,s.derivspj(:,k));
    end
    y=class(y,'derivspj');
elseif nargin == 4
    j=getval(j);
    m=getval(m);
    s=derivspj(s);
    y.val=sparse(i,j,s.val,m);
    % y.deriv = zeros(size(y.val),globp);
    for k = 1:globp
        y.derivspj{k}=sparse(i,j,s.derivspj(:,k),m);
    end
    y=class(y,'derivspj');
elseif nargin == 5
    j=getval(j);
    m=getval(m);
    n=getval(n);
    s=derivspj(s);
    y.val=sparse(i,j,s.val,m, n);
    %y.deriv = zeros(m, n,globp);
    for k = 1:globp
        y.derivspj{k}=sparse(i,j,s.derivspj(:,k),m, n);
    end
    y=class(y,'derivspj');    
    
else
    j=getval(j);
    m=getval(m);
    n=getval(n);
    s=derivspj(s);
    y.val=sparse(i,j,s.val,m,n, nzmax);
    %y.derivspj = zeros(m,n,globp);
    for k = 1:globp
        y.derivspj{k} =sparse(i,j,s.derivspj(:,k),m,n, nzmax);
    end
    y=class(y,'derivspj');
end
