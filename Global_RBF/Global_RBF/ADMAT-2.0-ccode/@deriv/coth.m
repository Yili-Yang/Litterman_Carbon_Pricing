function sout=coth(s1)
%
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

%
global globp;

sout.val=coth(s1.val);
[m1,n1]=size(getval(s1));
if issparse(s1.deriv)
    tmp = (-1) ./ sqr( sinh(full(s1.val(:))));
    sizederiv = size(s1.deriv,1);
    [ia,ja,sa] = find(s1.deriv);
    dsout = tmp(ia) .* sa;
    sout.deriv = sparse(ia,ja, dsout, sizederiv, globp);
else
    if m1 > 1 && n1 > 1         % s1.val is a matrix
        tmp = (-1) ./ sqr( sinh((s1.val)));
        sout.deriv = tmp(:,:, ones(1,globp)) .* s1.deriv;
    else      % s1.val is a column vector
        tmp = (-1) ./ sqr( sinh((s1.val)));
        tmp = tmp(:);
        sout.deriv = tmp(:, ones(1,globp)) .* s1.deriv;
    end
end
sout=class(sout,'deriv');