function sout=sqrt(s1)
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

global globp;
sout.val = sqrt(s1.val);
[m,n]=size(getval(sout.val));
% val=getval(sout.val);
tmp = 1./(2.*sout.val);

if m > 1 && n > 1
    error('derivtapeH does not support matrxi operations now!');
else
    if m == 1 && n==1
        sout.deriv = tmp .* s1.deriv;
    elseif m==1              % row vector
        sout.deriv = repmat(tmp(:),1,globp).*s1.deriv;
    else                 % column vector
        sout.deriv = repmat(tmp(:),1,globp).*s1.deriv;
    end
end
    

% sout.deriv = repmat(tmp(:),1,globp) .* s1.deriv;

sout = class(sout,'derivtapeH');
