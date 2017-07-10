function sout=power(s1,s2)
%
% 
%
%  March, 2007 -- reorganized the program for readibility
%  04/2007 -- consider all the cases for power
% 
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


sout = getval(s1).^getval(s2);
sout = derivH(sout);

if ~isempty(sout.val)
    [m,n]=size(sout.val);
    if ~isa(s1,'derivH')
        s2val = getvalue(s2);
        val2 = s1.^s2val.*log(s1);
        if m == 1 || n == 1
            sout.derivH = val2(:) .* s2.derivH;
        else
            sout.derivH = val2 .* s2.derivH;
        end
    elseif ~isa(s2,'derivS')
        s1val = getvalue(s1);
        val1 = s2.*(s1val.^(s2-1));
        if m == 1 || n == 1
            sout.derivH = val1(:) .* s1.derivH;
        else
            sout.derivH = val1 .* s1.derivH;
        end
    else
        s1val = getvalue(s1);
        s2val = getvalue(s2);
        val1 = s2val.*(s1val.^(s2val-1));
        val2 = s1val.^s2val.*log(s1val);
        if (m==1) || (n==1)           % sout.val is a vector
            sout.derivH = val1(:).*s1.derivH+...
                val2(:).*s2.derivH;
        else                          % sout.val is a matrix
            sout.derivH = val1.*s1.derivH + ...
                val2.*s2.derivH;
        end
    end
end

