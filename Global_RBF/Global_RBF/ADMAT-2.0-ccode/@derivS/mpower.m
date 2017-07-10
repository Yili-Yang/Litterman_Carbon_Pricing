function sout = mpower(s1,s2)
%
%
%  04/2007 -- consider the case for either s1 
%      or s2 is not a derivS object
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

sout= getval(s1)^getval(s2);
sout=derivS(sout);
if ~isempty(sout.val)
    if ~isa(s1, 'derivS')
        sout.derivS = sout.val.*log(s1).*s2.derivS;
    elseif ~isa(s2,'derivS')
        sout.derivS = s2.*(s1.val.^(s2-1)).*s1.derivS;
    else                   % both are derivS objects
        sout.derivS=s2.val.*(s1.val.^(s2.val-1)).*s1.derivS+...
            sout.val.*log(s1.val).*s2.derivS;
    end
else
    sout = [];
end
