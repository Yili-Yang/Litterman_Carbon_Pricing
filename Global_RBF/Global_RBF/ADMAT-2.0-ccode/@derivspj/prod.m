function sout=prod(s1)
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

%

sout.val=prod(s1.val);
sout.derivspj=sum(s1.derivspj);
sout=class(sout,'derivspj');
