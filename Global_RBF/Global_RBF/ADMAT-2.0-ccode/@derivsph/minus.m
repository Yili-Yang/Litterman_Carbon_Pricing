function sout = minus(s1,s2)
%
%
%  05/2007  --  consider the case for a scalar adding with a 
%               vector or matrix
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global globp;

if ~isa(s1,'derivsph')
    sout.val=s1-s2.val;
    if (length(getval(s2)) == 1) && length(getval(sout.val))>1
        sout.derivsph = cell(globp,globp);
        for i = 1 : globp
            for j = 1 : globp
                sout.derivsph{i,j} = s2.derivsph(i,j)*spones(s1);
            end
        end
    else
        sout.derivsph=s2.derivsph;
    end

elseif ~isa(s2,'derivsph')
    sout.val=s1.val-s2;
    if (length(getval(s1)) == 1) && length(getval(sout.val))>1
        sout.derivsph = cell(globp,globp);
        for i = 1 : globp
            for j = 1 : globp
                sout.derivsph{i,j} = s1.derivsph(i,j)*spones(s2);
            end
        end
    else
        sout.derivsph=s1.derivsph;
    end
else
    sout.val=s1.val-s2.val;
    sout.derivsph=s1.derivsph+s2.derivsph;
end


sout=class(sout,'derivsph');
