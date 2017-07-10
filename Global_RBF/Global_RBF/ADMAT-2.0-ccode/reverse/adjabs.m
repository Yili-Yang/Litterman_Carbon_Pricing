function adjabs(i)
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

%
global tape;
global globp;

val = tape(tape(i).arg1vc).val;
m = size(val);


    if m(2) == 1          % val is a column vector
        a = sign(val);
        a(a==0) = 1;
        tmp = a(:, ones(globp,1));
        tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W + tmp .* tape(i).W;
    elseif (m(1) == 1)    % val is a row vector
        a = sign(val(:));
        a(a==0) = 1;
        tmp = a(:, ones(globp,1));
        tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W + tmp .* tape(i).W;
    else                 % val is a matrix
        a  = sign(val);
        a(a==0) = 1;
        for k = 1 : globp
            tape(tape(i).arg1vc).W(:,:,k) = tape(tape(i).arg1vc).W(:,:,k) + a .* tape(i).W;
        end
    end
% index0 = (val == 0);
% tmp = tape(tape(i).arg1vc).W;
% if nnz(index0)>0 && norm(tmp(index0),1) ~= 0
%     error('Nondifferentiable points in abs() was detected.');
% end
