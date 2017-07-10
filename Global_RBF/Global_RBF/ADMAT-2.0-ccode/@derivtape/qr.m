function [Q,R]=qr(A)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

if nargout == 2
  [Q,R]=qr(A.val);
else
    Q = qr(A.val);
end
