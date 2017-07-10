function sout = minus(s1,s2)
%
% 
%
%   03/2007 -- consider the case when s1.val is a matrix
%   03/2007 -- rearrange the program for readibilty
%   04/2007 -- consider all cases for s1 and s2
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


sout=getval(s1)-getval(s2);
sout=derivH(sout);

if ~isempty(sout.val)
    [m,n]=size(sout.val);
    if ~isa(s1,'derivH')
        if (m==1) || (n==1)
            if length(s2.val)~=length(sout.val)
                sout.derivH = -repmat(s2.derivH,length(sout.val),1);
            else
                sout.derivH = -s2.derivH;
            end
        else
            [m2, n2] = size(s2.val);
            if m2 == 1 && n2 == 1
                sout.derivH = -repmat(s2.derivH,m,n);
            else
                sout.derivH = -s2.derivH;
            end
        end

    elseif ~isa(s2,'derivH')
        
        if (m==1) || (n==1)
            if length(s1.val)~=length(sout.val)
                sout.derivH = repmat(s1.derivH,length(sout.val),1);
            else
                sout.derivH = s1.derivH;
            end
        else
            [m1, n1] = size(s1.val);
            if m1 == 1 && n1 == 1
                sout.derivH = repmat(s1.derivH, m,n);
            else
                sout.derivH = s1.derivH;
            end
        end

    else

        sout.derivH = s1.derivH-s2.derivH;
    end

end

