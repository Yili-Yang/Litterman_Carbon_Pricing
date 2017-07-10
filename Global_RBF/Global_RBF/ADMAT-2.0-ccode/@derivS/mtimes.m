function sout=mtimes(s1,s2)
%
%

%   04/2007 -- add comments and reorganize the program
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

sout=getval(s1)*getval(s2);

sout=derivS(sout);

if ~isempty(sout.val)
    [m1,n1]=size(getval(s1));
    [m2,n2]=size(getval(s2));

    if (~isa(s1,'derivS'))           % s1 is not an instance of derivS

        if ((m1>1)&&(n1>1))
            sout.derivS=s1*s2.derivS;
        elseif ((m2>1)&&(n2>1))
            sout.derivS = s2.derivS' * s1';
        else
            if ((length(s1)==1) || (length(s2.val)==1))    % either s1 or s2.val is a scalar
                q=s1.*s2.derivS;
                sout.derivS=q(:);
            elseif (m1 == 1)
                %Inner product
                sout.derivS=s1*s2.derivS;
            else
                %outer product
                sout.derivS=s1*s2.derivS';
            end
        end
    elseif  (~isa(s2,'derivS'))              % s2 is not an instance of derivS
        if ((m1>1) && (n1>1))
            sout.derivS=s1.derivS*s2;
        elseif ((m2>1) && (n2>1))
            sout.derivS = s2' * s1.derivS;
        else
            if ((length(s1.val)==1) || (length(s2)==1))
                p=s2.*s1.derivS;
                sout.derivS=p(:);
            elseif (m1 == 1)
                %Inner product
                sout.derivS=s2'*s1.derivS;
            else
                %outer product
                sout.derivS=s1.derivS*s2;
            end
        end

    else                               % both s1.val and s2.val are instances
                                       % of derivS
        if ((m1>1) && (n1>1))
            sout.derivS=s1.derivS*s2.val+s1.val*s2.derivS;
        elseif ((m2>1) && (n2>1))
            sout.derivS = s2.val'*s1.derivS + s2.derivS' * s1.val';
        else
            if ((length(s1.val)==1) || (length(s2.val)==1))
                p=s2.val.*s1.derivS;
                q=s1.val.*s2.derivS;
                sout.derivS=p(:)+q(:);
            elseif (m1 == 1)
                %Inner product
                sout.derivS=s2.val'*s1.derivS+s1.val*s2.derivS;
            else
                %outer product
                sout.derivS=s1.derivS*s2.val+s1.val*s2.derivS';
            end
        end

    end

end
