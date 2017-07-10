function [m,n]=size(s1,p)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

if nargin==1
    if nargout ==2
        [m,n]=size(s1.val);
        m=derivtape(m,0);
        n=derivtape(n,0);
    else
        [m1,n1]=size(s1.val);
        m=[m1 n1];
        m=derivtape(m);
    end
else
    m=size(s1.val,p);
    m=derivtape(m,0);
end
