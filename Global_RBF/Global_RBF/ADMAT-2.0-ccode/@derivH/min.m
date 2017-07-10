function [sout,I] = min(s1,s2)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


if nargout==2
    if nargin==2
        [sout,I]=max(-s1,-s2);
    else
        [sout,I]=max(-s1);
    end
    sout=-sout;
else
    if nargin==2
        sout=-max(-s1,-s2);
    else
        sout=-max(-s1);
    end


end
