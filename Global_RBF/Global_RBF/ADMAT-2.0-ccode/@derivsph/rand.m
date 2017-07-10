function y = rand(m,n)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

if nargin ==1
    y= derivsph(rand(getval(m)));
else
    y= derivsph(rand(getval(m),getval(n)));
end
