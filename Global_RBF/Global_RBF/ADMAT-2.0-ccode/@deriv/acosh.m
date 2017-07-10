function sout=acosh(s1)
%
%   overloaded acosh operation
%
%   
%
%   03/2007 -- matrix operation is used to avoid 
%              "for" loop to improve the performance.
%   03/2007 -- consider the case when s1.val is a matrix
%   03/2007 -- if s1.val is a vector, it has to be a 
%              column vector.
%   03/2007 -- correct the computation of derivatives of cosh(x).
%   04/2007 -- consider the case s1.val is a row vector
%   05/2009 -- add the sparse case for deriv field.
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


global globp;
sout.val=acosh(s1.val);
[m1,n1]=size(getval(s1));
if issparse(s1.deriv)
    val = full(s1.val(:));
    tmp = 1./(sqrt(val +1) .* sqrt(val - 1));
    sizederiv = size(s1.deriv,1);
    [ia,ja,sa] = find(s1.deriv);
    dsout = tmp(ia) .* sa;
    sout.deriv = sparse(ia,ja, dsout, sizederiv, globp);
else
    if m1 > 1 && n1 > 1         % s1.val is a matrix
        tmp = 1./(sqrt(s1.val +1) .* sqrt(s1.val - 1));
        sout.deriv = tmp(:,:, ones(1,globp)) .* s1.deriv;
    else
        tmp = 1./(sqrt(s1.val +1) .* sqrt(s1.val - 1));
        tmp = tmp(:);
        sout.deriv = tmp(:, ones(1,globp)) .* s1.deriv;
    end

end
sout=class(sout,'deriv');
