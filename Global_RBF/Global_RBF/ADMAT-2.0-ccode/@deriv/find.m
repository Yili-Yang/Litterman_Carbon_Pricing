function [ia,ja, sa]=find(x)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


if nargout==1
    ia=find(x.val);
elseif nargout == 2
    [ia,ja]=find(x.val);
else
    [ia,ja,sa] = find(x.val);
end
