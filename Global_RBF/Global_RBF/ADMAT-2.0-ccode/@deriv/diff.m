function sout=diff(s1, N, DIM)

%
%   revised May 6th, 2008
%   -add more input arguments N and DIM.
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


global globp;

s1val = getval(s1);
[m, n] = size(s1val);
if nargin == 1
    N = 1;
    if m == 1
        DIM = 2;
    else
        DIM = 1;
    end
else if nargin == 2
        if m == 1
            DIM = 2;
        else
            DIM = 1;
        end
    end
end

sout.val=diff(getval(s1),N, DIM);

if nargin < 3 && m == 1
    DIM = 1;
end
sout.deriv=squeeze(diff(s1.deriv, N, DIM));

[m,n]=size(sout.val);
if (m==1) && (globp==1)
    sout.deriv=sout.deriv(:);
end
sout=class(sout,'deriv');
