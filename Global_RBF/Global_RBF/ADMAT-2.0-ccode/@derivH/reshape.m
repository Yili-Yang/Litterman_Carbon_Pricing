function y = reshape(x,m,n)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


m=derivH(m);
if nargin ==3
    n=derivH(n);
end

if ~isa(x,'derivH')
    y=reshape(x,m.val,n.val);

else

    if nargin ==2
        y=reshape(x.val,m.val);
    else
        y=reshape(x.val,m.val,n.val);
    end
    y=derivH(y);
    if nargin ==2
        y.derivH=reshape(x.derivH,m.val);
    else
        y.derivH=reshape(x.derivH,m.val,n.val);
    end

end
