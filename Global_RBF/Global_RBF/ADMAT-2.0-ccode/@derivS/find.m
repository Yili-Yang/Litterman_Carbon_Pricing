function [out1,out2]=find(x)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

if nargout==1
    out1=find(x.val);
else
    [out1,out2]=find(x.val);
end
