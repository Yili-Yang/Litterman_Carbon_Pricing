function y = reshape(x,m,n)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

m=derivsph(m);
if nargin ==3
    n=derivsph(n);
end


if ~isa(x,'derivsph')
    if nargin ==2
        y=reshape(x,m.val);
    else
        y=reshape(x,m.val,n.val);
    end
else
    if nargin ==2
        y=reshape(x.val,m.val);
    else
        y=reshape(x.val,m.val,n.val);
    end
    y=derivsph(y);
    y.derivsph=reshapecell(x.derivsph,getval(m),getval(n));
end
