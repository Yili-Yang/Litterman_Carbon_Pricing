function [V, E]=eig(s1)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

if nargout == 2
    [V, E] = eig(s1.val);
else
    V =eig(s1.val);
end
