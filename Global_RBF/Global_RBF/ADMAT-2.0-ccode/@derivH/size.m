function [m,n]=size(s1,p)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


if nargin==1
    if nargout ==2
        [m,n]=size(s1.val);
        m=derivH(m);
        n=derivH(n);
    else
        m=size(s1.val);
        m=derivH(m);
    end
else
    m=size(s1.val,p);
    m=derivH(m);
end
