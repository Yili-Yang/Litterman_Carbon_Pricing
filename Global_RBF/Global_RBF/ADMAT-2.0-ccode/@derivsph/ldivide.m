function sout = ldivide(s1,s2)
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

%
% 04/2007 -- removed unused variables
%

if ~isa(s2,'derivsph')
    sout.val=s1.val.\s2;
elseif ~isa(s1,'derivsph') 
    sout.val=s1.\s2.val;
else
    sout.val=s1.val.\s2.val;
end

sout.derivsph=updatesph2(s1,s2);

sout=class(sout,'derivsph');
