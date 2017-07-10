function sout=exp(s1)
%
%
% 05/2007 -- correct the derivative computation
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

tval = s1.val;
sout.val = exp(tval);

tmp = exp(tval);
tderiv = s1.deriv;
sout.deriv = repmat(tmp(:),1, globp) .* tderiv;

sout=class(sout,'derivtapeH');
