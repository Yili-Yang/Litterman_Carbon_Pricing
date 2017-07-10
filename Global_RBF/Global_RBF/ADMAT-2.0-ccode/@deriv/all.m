function y=all(V,dim)

%  devloped by 05/2009
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


if nargin == 1
  y=all(getval(V));
else
    y = all(getval(V), getval(dim));
end
