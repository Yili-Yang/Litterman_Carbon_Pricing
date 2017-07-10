function sout=exp(s1)
%
%
%   03/2007 -- matrix operation is used to avoid 
%              "for" loop to improve the performance.
%   03/2007 -- consider the case when s1.val is a matrix
%   03/2007 -- if s1.val is a vector, it has to be a 
%              column vector
%   05/2009 -- add the sparse case for deriv field.
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


global globp;
sout.val=exp(s1.val);
[m1,n1]=size(getval(s1));
if issparse(s1.deriv)
    tmp = sout.val(:);
    [ia,ja,sa] = find(s1.deriv);    
    sout.deriv = tmp(ia) .* sa;
    sizeax = size(sout.deriv,1);
    sout.deriv = sparse(ia,ja,sout.deriv,sizeax,globp);
else
    if m1 > 1 && n1 > 1         % s1.val is a matrix
        tmp = sout.val;
        sout.deriv = tmp(:,:, ones(1,globp)) .* s1.deriv;
    elseif m1 > 1  || n1 > 1        % s1.val is a column/row vector
        tmp = sout.val;
        tmp = tmp(:)  ;
        sout.deriv = tmp(:, ones(1,globp)) .* s1.deriv;
    else         % s1.val is a scalar
        sout.deriv = sout.val.* s1.deriv;
    end
end

sout=class(sout,'deriv');
