function sout=abs(s1)

%  01/2010 -- add nondifferentiable points detecting.
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

sout.val=abs(s1.val);
[m, n] =size(s1.val);

% non differentiable points checking

s1val = getvalue(s1);
index0 = (s1val == 0);
tmp = getydot(s1);

if m==1
    % non differentiable points checking
    if nnz(index0)>0 && norm(tmp(index0),1) ~= 0
        error('Nondifferentiable points in abs() was detected.');
    else
        sout.derivS = sign(s1.val)' .* s1.derivS;
    end
else
    % non differentiable points checking
    if nnz(index0)>0 && norm(tmp(index0),1) ~= 0
        error('Nondifferentiable points in abs() was detected.');
    else
        sout.derivS = sign(s1.val) .* s1.derivS;
    end
end

sout=class(sout,'derivS');
