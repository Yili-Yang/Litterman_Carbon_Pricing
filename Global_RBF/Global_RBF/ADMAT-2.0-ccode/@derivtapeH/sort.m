function [Y,I]=sort(x,dim)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

if nargin ==2
    if nargout ==2
        [Y,I]=sort(x.val,dim);
    else
        Y=sort(x.val,dim);
    end
else
    if nargout ==2
        [Y,I]=sort(x.val);
    else
        Y=sort(x.val);
    end
end
