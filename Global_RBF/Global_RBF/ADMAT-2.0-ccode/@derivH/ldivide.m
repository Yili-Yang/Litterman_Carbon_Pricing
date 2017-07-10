function sout = ldivide(s2,s1)
%
%
%
%  March, 2007 -- correct the computation of 
%                 the derivative.
%  04/2007 -- consider the case for row vectors
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

if ~isa(s2, 'derivH')      % s2 is not a derivH object
    sout.val = s2 .\ s1.val;
    [m,n] = size(sout.val);
    % s1val=getvalue(s1);
    tmp = 1./s2;
    if m == 1 || n == 1
        sout.derivH = tmp(:).*s1.derivH;
    else
        sout.derivH = tmp .* s1.derivH;
    end
elseif ~isa(s1, 'derivH')        % s1 is not a derivH object
    sout.val = s2.val .\ s1;
    [m,n] = size(sout.val);
    s2val = getvalue(s2);
    tmp = -s1./(s2val.*s2val);
    if m == 1 || n == 1
        sout.derivH = tmp(:).*s2.derivH;
    else
        sout.derivH = tmp .* s2.derivH;
    end
else         % both are deriv objects
    sout.val = s2.val .\ s1.val;
    [m,n] = size(sout.val);
    s1val = getvalue(s1);
    s2val = getvalue(s2);
    tmp1 = 1./s2val;
    tmp2 = -s1val ./ (s2val.*s2val);
    if m == 1 || n == 1
        sout.derivH = tmp1(:) .* s1.derivH + tmp2(:).*s2.derivH;
    else
        sout.derivH = tmp1 .* s1.derivH + tmp2 .* s2.derivH;
    end
end

sout = class(sout, 'derivH');
