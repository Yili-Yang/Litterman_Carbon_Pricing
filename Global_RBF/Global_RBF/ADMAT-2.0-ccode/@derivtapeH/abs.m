function sout = abs(s1)
%
%
% 05/2007 -- limited the case that input, 's1' is a scalar or vector. 
%            The matrix case will involve 4-dimensional arrary in the
%            computation, which is not supported in 'reverse' folder.
%  01/2010 -- add nondifferentiable points detecting.
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global globp;

[m,n] = size(s1.val);
% non differentiable points checking

s1val = getvalue(s1);
index0 = (s1val == 0);
tmp = getydot(s1);

sout.val=abs(s1.val);

if nnz(index0)>0 && norm(tmp(index0),1) ~= 0
    error('Nondifferentiable points in abs() was detected.');
else
    tmp = sign(s1.val);
    sout.deriv = repmat(tmp(:), 1, globp) .* s1.deriv;
end

sout=class(sout,'derivtapeH');
