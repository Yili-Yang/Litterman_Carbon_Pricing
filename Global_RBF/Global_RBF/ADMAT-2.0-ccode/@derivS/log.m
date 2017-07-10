function sout = log(s1)
%
%
%  04/2007 -- consider the case for row vectors
% 
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

sout.val=log(s1.val);
[m,n]=size(sout.val);

if m==1 || n==1
    sout.derivS=s1.derivS./s1.val(:);
else
    sout.derivS=s1.derivS./s1.val;
end
sout=class(sout,'derivS');
