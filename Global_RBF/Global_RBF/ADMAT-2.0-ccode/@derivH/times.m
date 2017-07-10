function sout=times(s1,s2)
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

if ~isempty(s1) && ~isempty(s2)
    sout=getval(s1).*getval(s2);
    [m,n] = size(sout);
    sout=derivH(sout);
    
    if ~isempty(sout.val)
        if ~isa(s1,'derivH')
            if m == 1 || n == 1
                sout.derivH = s1(:) .* s2.derivH;
            else
                sout.derivH = s1.*s2.derivH;
            end
        elseif ~isa(s2,'derivH')
            if m == 1 || n == 1
                sout.derivH = s2(:) .* s1.derivH;
            else
                sout.derivH = s2.*s1.derivH;
            end
        else
            s2d=getvalue(s2);
            s1d=getvalue(s1);
            if m == 1 || n == 1
                sout.derivH = s2d(:).*s1.derivH+...
                    s1d(:).*s2.derivH;
            else
                sout.derivH=s2d.*s1.derivH+...
                    s1d.*s2.derivH;
            end
        end
    end
else
    sout=[];
end
