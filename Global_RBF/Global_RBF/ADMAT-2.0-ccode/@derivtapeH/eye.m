function y = eye(m,n)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

if nargin == 1
    n = m;
end

y=eye(m.val,n.val);

y=derivtapeH(y,0);
