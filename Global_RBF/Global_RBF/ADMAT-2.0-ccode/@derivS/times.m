function sout=times(s1,s2)
%
%
%
%   March, 2007 -- add comments and reorganize the program
%   March, 2007 -- simplify the programming.
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

if ~isempty(s1) && ~isempty(s2)
    sout=getval(s1).*getval(s2);
    [m,n] = size(sout);
    sout=derivS(sout);
    if ~isempty(sout.val)
        if ~isa(s1,'derivS')
            if (m==1) || (n==1)
                sout.derivS=s1(:).*s2.derivS;
            else
                sout.derivS=s1.*s2.derivS;
            end
        elseif ~isa(s2,'derivS')
            if (m==1) || (n==1)
                sout.derivS=s2(:).*s1.derivS;
            else
                sout.derivS=s2.*s1.derivS;
            end

        else                % both s1 and s2 are instances of derivS
            if (m==1) || (n==1)
                sout.derivS=s2.val(:).*s1.derivS+...
                    s1.val(:).*s2.derivS;
            else
                sout.derivS=s2.val.*s1.derivS+...
                    s1.val.*s2.derivS;
            end
        end
    end
else
    sout=[];
end
