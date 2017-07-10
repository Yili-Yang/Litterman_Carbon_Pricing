function sout=transpose(s1)
%
%
%  04/2007 -- rmoved unused variables
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

sout.val=s1.val';
[m,n] = size(s1.val);

if m > 1 && n >1
    for i = 1  : globp
        sout.derivspj{i}=s1.derivspj{i}';
    end
else
    sout.derivspj=s1.derivspj;
end

sout=class(sout,'derivspj');
