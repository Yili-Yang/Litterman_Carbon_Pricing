function y=repmat(x,M,DIM)
%
%   03/2007 -- rearrage the program for readibility
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


global globp;

m=getval(M);
if nargin < 3
    if length(m)==2
        n=m(2);
        m = m(1);
    else
        n=m;
    end
else
    n=getval(DIM);
end

if ~isa(x,'deriv')
    y=deriv(repmat(x,m,n));

else
    y=repmat(x.val,m,n);
    y=deriv(y);

    [p,q]=size(x.val);
    [p1,q1]=size(y.val);
    if (p==1) &&(q~=1)
        if (p1==1) &&(q1~=1)
            for i=1:globp 
                y.deriv(:,i)=repmat(x.deriv(:,i)',m,n)';
            end
        else
            for i=1:globp 
                y.deriv(:,:,i)=repmat(x.deriv(:,i)',m,n);
            end
        end

    else
        if (p1==1) ||(q1==1)
            for i=1:globp 
                y.deriv(:,i)=repmat(x.deriv(:,i),m,n); 
            end
        else
            for i=1:globp 
                y.deriv(:,:,i)=repmat(x.deriv(:,i),m,n); 
            end
        end
    end

end
