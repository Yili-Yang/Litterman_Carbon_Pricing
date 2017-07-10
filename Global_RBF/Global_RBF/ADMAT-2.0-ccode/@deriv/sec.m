function sout=sec(s1)
%
% 
%
%   03/2007 -- matrix operation is used to avoid 
%              "for" loop to improve the performance.
%   03/2007 -- consider the case when s1.val is a matrix
%   03/2007 -- if s1.val is a vector, it has to be a 
%              column vector.
%   04/2007 -- consider the case s1.val is a row vector
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


global globp;

sout.val=sec(s1.val);
[m1,n1]=size(getval(s1));
tmp = sec(s1.val) .* tan(s1.val);
    
if m1 > 1 && n1 > 1
    sout.deriv = tmp(:,:,ones(1,globp)) .* s1.deriv;
else
    tmp = tmp(:);
    sout.deriv = tmp(:,ones(1,globp)) .* s1.deriv;
end

sout=class(sout,'deriv');
