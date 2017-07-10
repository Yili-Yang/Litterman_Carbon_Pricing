function sout=abs(s1)
%
% 
%
%  04/2007 -- consider the case for row vectors
%  01/2010 -- add nondifferentiable points detecting.
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


[m,n] = size(s1.val);
sout.val = abs(s1.val);



s1val = getvalue(s1);
index0 = (s1val == 0);
tmp = getydot(s1);
if m == 1            % row vector
    % non differentiable points checking
    if nnz(index0)>0 && norm(tmp(index0),1) ~= 0
        error('Nondifferentiable points in abs() was detected.');
    else
        sout.derivH = sign(s1val(:)).*s1.derivH;
    end
else
    % non differentiable points checking
    if nnz(index0)>0 && norm(tmp(index0),1) ~= 0
        error('Nondifferentiable points in abs() was detected.');
    else
        sout.derivH = sign(s1val).*s1.derivH;
    end
end

sout = class(sout,'derivH');
