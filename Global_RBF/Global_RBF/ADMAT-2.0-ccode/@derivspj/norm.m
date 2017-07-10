function normout=norm(x,p)
%
%
%  04/2007 -- rmoved unused variables
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

if nargin == 1
    p = 2;
end
normout.val=norm(x.val,p);
normout.derivspj=sum(x.derivspj);
normout=class(normout,'derivspj');
