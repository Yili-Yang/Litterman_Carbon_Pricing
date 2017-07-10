function sout=ldivide(s1,s2)
%
%
%  04/2007 -- rmoved unused variables
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

sout.val=getval(s1).\getval(s2);

if ~isempty(sout.val)
    sout.derivspj=updatespj(s1,s2);
else
    sout.derivspj=[];
end

sout=class(sout,'derivspj');