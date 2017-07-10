function y=repmat(x,m,n)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


m=derivH(m);
if nargin < 3 
    n=m; 
else
    n=derivH(n); 
end

if ~isa(x,'derivH')
    y=repmat(x,m.val,n.val);
else
    y=repmat(x.val,m.val,n.val);
    y=derivH(y);
    [p,q]=size(x.val);
    [p1,q1]=size(y.val);

    if (p==1) && (q~=1)
        if (p1==1) &&(q1~=1)
            y.derivH=repmat(x.derivH',m.val,n.val)';
        else
            y.derivH=repmat(x.derivH',m.val,n.val);
        end

    else
        y.derivH=repmat(x.derivH,m.val,n.val);
    end

end
