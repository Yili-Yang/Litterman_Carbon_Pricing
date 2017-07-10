function sout=log10(s1)
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


m = size(s1.val,1);
sout.val=log10(s1.val);

tmp = getvalue(s1)*log(10);
if m == 1
    sout.derivH=s1.derivH./tmp(:);
else
    sout.derivH = s1.derivH./tmp;
end

sout=class(sout,'derivH');
