function y=sparse(i,j,s,m,n, nzmax)
%
%  Modified Sep. 8th, 2013 -- support all cases in Matlab.
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global globp;

i=getval(i);
if nargin == 1
    y=sparse(i);
    y=deriv(y);
elseif nargin == 2
    j=getval(j);
    y=sparse(i,j);
    y=deriv(y);
elseif nargin == 3
    j=getval(j);
    s = deriv(s);
    y.val=sparse(i,j,getval(s));
    for k = 1:globp
        y.deriv(:,:,k)=sparse(i,j,s.deriv(:,k));
    end
    y=class(y,'deriv');
elseif nargin == 4
    j=getval(j);
    m=getval(m);
    s=deriv(s);
    y.val=sparse(i,j,s.val,m);
    y.deriv = zeros(size(y.val),globp);
    for k = 1:globp
        y.deriv(:,:,k)=sparse(i,j,s.deriv(:,k),m);
    end
    y=class(y,'deriv');
elseif nargin == 5
    j=getval(j);
    m=getval(m);
    n=getval(n);
    s=deriv(s);
    y.val=sparse(i,j,s.val,m, n);
    y.deriv = zeros(m, n,globp);
    for k = 1:globp
        y.deriv(:,:,k)=sparse(i,j,s.deriv(:,k),m, n);
    end
    y=class(y,'deriv');    
    
else
    j=getval(j);
    m=getval(m);
    n=getval(n);
    s=deriv(s);
    y.val=sparse(i,j,s.val,m,n, nzmax);
    y.deriv = zeros(m,n,globp);
    for k = 1:globp
        y.deriv(:,:,k) =sparse(i,j,s.deriv(:,k),m,n, nzmax);
    end
    y=class(y,'deriv');
end
