function HV = evalHfor(fun,x,Extra)
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


if nargin < 3 Extra=[]; end

n=length(x);

HV=zeros(n);

for i=1:n
HV(i,i)=VHtimesV(fun,x,[zeros(i-1,1);1;zeros(n-i,1)],Extra);
for j= i+1:n

HV(i,j)= WHtimesV(fun,x,[zeros(j-1,1);1;zeros(n-j,1)],[zeros(i-1,1);1;zeros(n-i,1)],Extra);
HV(j,i)=HV(i,j);
end
end
