function [m,n]=size(s1,p)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

if nargin==1
    if nargout ==2
        [m,n]=size(getval(s1));
%         m=derivtapeH(m,0);
%         n=derivtapeH(n,0);
    else
        [m1,n1]=size(getval(s1));
        m=[m1 n1];
%         m=derivtapeH(m);
    end
else
    m=size(getval(s1),p);
%     m=derivtapeH(m,0);
end
