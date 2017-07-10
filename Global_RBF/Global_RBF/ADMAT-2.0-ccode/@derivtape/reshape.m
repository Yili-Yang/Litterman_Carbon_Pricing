function y=reshape(x,m,n)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global varcounter;

if ~isa(x,'derivtape') 
    x=derivtape(x); 
end

if nargin ==2
    y.val=reshape(x.val,getval(m));
else
    y.val=reshape(x.val,getval(m),getval(n));
end

[mm,nn]=size(x.val);
y.varcount=varcounter;
y=class(y,'derivtape');

savetape('reshape',y,x.varcount,mm,nn);
