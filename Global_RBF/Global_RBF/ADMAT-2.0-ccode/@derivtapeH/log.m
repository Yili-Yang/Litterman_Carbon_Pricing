function sout = log(s1)
%
%
% 05/2007 -- limited the case that input, 's1' is a scalar or vector. 
%            The matrix case will involve 4-dimensional arrary in the
%            computation, which is not supported in 'reverse' folder.
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global globp
sout.val = log(s1.val);

[m1, n1] = size(getval(s1.val));
%tmp = 1./s1.val;

if m1 > 1 && n1 > 1        % s1.val is a matrix
    error(' derivtapH does not support matrix operations now! ');
else
    if m1 > 1      % s1.val is a column vector
        tmp = 1./s1.val;
        sout.deriv = tmp(:, ones(1,globp)) .* s1.deriv;
    else
        if n1 == 1   % s1.val is a scalar
            sout.deriv = (1./s1.val) .* s1.deriv;
        else         % s1.val is a row vector
            tmp = 1./s1.val;
            tmp = tmp(:);
            sout.deriv = tmp(:, ones(1,globp)) .* s1.deriv;
        end
    end
end

%sout.deriv = repmat(tmp(:), 1, globp) .* s1.deriv;

sout=class(sout,'derivtapeH');
