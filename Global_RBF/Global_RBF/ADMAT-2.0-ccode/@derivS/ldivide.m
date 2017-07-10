function sout=ldivide(s2,s1)
%
%  
%
%  04/2007 -- consider the case for row vectors
% 
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

sout = getval(s2).\getval(s1);
sout=derivS(sout);
[m,n]=size(sout.val);
if ~isempty(sout.val)
    if ~isa(s1, 'derivS')
        tmp = -s1./(s2.val.*s2.val);
        if m == 1 || n == 1
            sout.derivS = tmp(:) .* s2.derivS;
        else
            sout.derivS = tmp .* s2.derivS;
        end
    elseif ~isa(s2, 'derivS')
        tmp = 1./s2;
        if m == 1 || n == 1
            sout.derivS = tmp(:) .* s1.derivS;
        else
            sout.derivS = tmp .* s1.derivS;
        end
    else             % both s1 and s2 are derivS objects
        tmp1 = 1./s2.val;
        tmp2 = s1.val./(s2.val.*s2.val);
        if m == 1 || n == 1
            sout.derivS=tmp1(:).*s1.derivS-...
                tmp2(:).*s2.derivS;
        else
            sout.derivS=tmp1.*s1.derivS-...
                tmp2.*s2.derivS;
        end
    end
end
