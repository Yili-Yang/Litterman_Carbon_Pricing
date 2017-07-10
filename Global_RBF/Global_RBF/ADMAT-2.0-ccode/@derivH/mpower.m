function sout = mpower(s1,s2)
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

sout.val = getval(s1)^getval(s2);

if ~isempty(sout.val)
    if ~isa(s1, 'derivH')
        s2val = getvalue(s2);
        tmp = s1^s2val;
        sout.derivH = tmp .*log(s1) .* s2.derivH;
    elseif ~isa(s2,'derivH')
        s1val = getvalue(s1);
        sout.derivH = s2.*(s1val.^(s2-1)).*s1.derivH;
    else                   % both are derivS objects
        s1val = getvalue(s1);
        s2val = getvalue(s2);
        tmp = s1val^s2val;
        sout.derivH = s2val.*(s1val.^(s2val-1)).*s1.derivH+...
            tmp.*log(s1val).*s2.derivH;
    end
else
    sout = [];
end

sout = class(sout, 'derivH');