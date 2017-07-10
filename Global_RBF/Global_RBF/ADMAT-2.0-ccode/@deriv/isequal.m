function out=isequal(x,y,z,a)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


if nargin == 2
  x=getval(x);
  y=getval(y);
  out=isequal(x,y);
elseif nargin == 3
    x=getval(x);
    y=getval(y);
    z=getval(z);
    out = isequal(x,y,z);
elseif nargin == 4
    x=getval(x);
    y=getval(y);
    z=getval(z);
    a = getval(a);
    out = isequal(x,y,z,a);
end
        
        
