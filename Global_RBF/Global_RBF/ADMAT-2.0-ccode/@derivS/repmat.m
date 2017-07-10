function y=repmat(x,m,n)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

m=getval(m);

if nargin < 3
    if length(m)==2
        n=m(2);
        m = m(1);
    else
        n=m;
    end

else
    n=getval(n);
end

if ~isa(x,'derivS')
    y=derivS(repmat(x,m,n));
else
    y=repmat(x.val,m,n);
    y=derivS(y);

    [p,q]=size(x.val);
    [p1,q1]=size(y.val);

    if (p==1) && (q~=1)
        if (p1==1) && (q1~=1)
            y.derivS=repmat(x.derivS',m,n)';
        else
            y.derivS=repmat(x.derivS',m,n);
        end
    else
        y.derivS=repmat(x.derivS,m,n);
    end

end
