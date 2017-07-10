function sout=minus(s1,s2)
%
%
%  04/2007 -- consider all case 
%
% 
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

sout=getval(s1)-getval(s2);
sout=derivS(sout);
if ~isempty(sout.val)
    [m,n]=size(sout.val);
    if ~isa(s1,'derivS')

        if (m==1) || (n==1)
            if length(s2.val)~=length(sout.val)
                sout.derivS=-repmat(s2.derivS,length(sout.val),1);
            else
                sout.derivS=-s2.derivS;
            end
        else
            [m2, n2] = size(s2.val);
            if m2 == 1 && n2 == 1
                sout.derivS = -repmat(s2.derivS, m,n);
            else
                sout.derivS=-s2.derivS;
            end
        end

    elseif ~isa(s2,'derivS')
        if (m==1) || (n==1)
            if length(s1.val)~=length(sout.val)
                sout.derivS=repmat(s1.derivS,length(sout.val),1);
            else
                sout.derivS=s1.derivS;
            end
        else
            [m1, n1] = size(s1.val);
            if m1 == 1 && n1 == 1
                sout.derivS = repmat(s1.derivS, m,n);
            else
                sout.derivS=s1.derivS;
            end
        end

    else
        sout.derivS=s1.derivS-s2.derivS;
    end

end

