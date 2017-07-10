function sout=mldivide(s1,s2)
%
%  
%
%  March, 2007 -- correct the computation of 
%                 the derivative.
%  04/2007 -- consider all case for matrix division.
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

sout.val = getval(s1)\getval(s2);

if ~isempty(sout.val)
    if ~isa(s1,'derivH')
        m2 = size(s2.val,1);
        if m2 == 1           % s2.val is a row vector
            sout.derivH = s1\s2.derivH';
        else
            sout.derivH = s1\s2.derivH;
        end
    elseif ~isa(s2,'derivH')
        m1 = size(s1.val,1);
        s1val = getvalue(s1);
        if m1 == 1
            sout.derivH = s1val\(-s1.derivH' * (s1val\s2));
        else
            sout.derivH = s1val\(-s1.derivH * (s1val\s2));
        end
    else                      % both s1 and s2 are instances of derivS
        m2=size(s2.val,1);
        s1val = getvalue(s1);
        s2val = getvalue(s2);
        tmp = s1val\s2val;
        if m2==1
            sout.derivH = s1val\(s2.derivH'- s1.derivH' * tmp);
        else
            sout.derivH = s1val\(s2.derivH - s1.derivH * tmp);
        end
    end
    sout=class(sout,'derivH');
else
    sout=[];
end

