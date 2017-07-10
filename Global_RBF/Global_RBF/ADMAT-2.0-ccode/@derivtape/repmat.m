function y=repmat(x,m,n)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global varcounter;

if ~isa(x, 'derivtape')
    x=derivtape(x,0);
end

mval = getval(m);


if nargin ==2
    y.val=repmat(x.val,mval);
else
    nval = getval(n);
    y.val=repmat(x.val,mval,nval);
end

y.varcount=varcounter;
y=class(y,'derivtape');

if nargin==2
    savetape('repmat',y,x.varcount,mval);
else
    savetape('repmat',y,x.varcount,mval,nval);
end
