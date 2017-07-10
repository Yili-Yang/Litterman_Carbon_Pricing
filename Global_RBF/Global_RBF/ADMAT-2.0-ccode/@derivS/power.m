function sout=power(s1,s2)
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

sout=getval(s1).^getval(s2);
sout=derivS(sout);

if ~isempty(sout.val)
    [m,n]=size(sout.val);
    if ~isa(s1,'derivS')
        val2 = sout.val.*log(s1);
        if m == 1 || n == 1
            sout.derivS = val2(:) .* s2.derivS;
        else
            sout.derivS = val2 .* s2.derivS;
        end
    elseif ~isa(s2,'derivS')
        val1 = s2.*(s1.val.^(s2-1));
        if m == 1 || n == 1
            sout.derivS = val1(:) .* s1.derivS;
        else
            sout.derivS = val1 .* s1.derivS;
        end
    else
        val1=s2.val.*(s1.val.^(s2.val-1));
        val2=sout.val.*log(s1.val);
        if (m==1) || (n==1)           % sout.val is a vector
            sout.derivS=val1(:).*s1.derivS+...
                val2(:).*s2.derivS;
        else                          % sout.val is a matrix
            sout.derivS=s2.val.*(s1.val.^(s2.val-1)).*s1.derivS+...
                sout.val.*log(s1.val).*s2.derivS;
        end
    end
end
