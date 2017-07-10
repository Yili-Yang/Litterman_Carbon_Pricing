function sout=sum(s1, DIM)
%
%  
%
%   03/2007 -- matrix operation is used to avoid 
%              "for" loop to improve the performance.
%   03/2007 -- consider the case when s1.val is a matrix
%   03/2007 -- if s1.val is a vector, it has to be a 
%              column vector
%   03/2007 -- rearrage the program for readibility
%   04/2008 -- add input argument DIM
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


global globp;
if nargin == 1
    DIM = 1;
end
m = size(s1.val);

if length(m) == 2
    if (m(1) == 1 || m(2) == 1) && DIM == 1
        sout.val = sum(s1.val);
    else
        sout.val = sum(s1.val, DIM);
    end
else
    sout.val = sum(s1.val, DIM);
end

if globp == 1
    if length(m) == 3
        sout.deriv = sum(s1.deriv, DIM);
    else
        sout.deriv = sum(s1.deriv, DIM);
        sout.deriv = sout.deriv(:);
    end
else
    if length(m) == 3
        sout.deriv = squeeze(sum(s1.deriv, DIM));
    elseif m(1)~=1 && m(2)~=1          % s1.val is a matrix
        sout.deriv = squeeze(sum(s1.deriv,DIM));

    elseif m(1)~=1 || m(2) ~= 1                 % s1.val is a vector
        if DIM == 1
            sout.deriv = sum(s1.deriv);
        else
            sout.deriv = s1.deriv;
        end
    else          % s1.val is a scalar
        sout.deriv = s1.deriv;% 
    end

end

sout=class(sout,'deriv');
