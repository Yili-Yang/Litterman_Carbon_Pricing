function adjdiag(i)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global tape;
global globp;

V = tape(tape(i).arg1vc).val;
[m,n] = size(V);

if m == 1 || n == 1
    if ~isempty(tape(i).arg2vc)
        k = tape(i).arg2vc;
        for j = 1 : globp
            tape(tape(i).arg1vc).W(:,j)= diag(tape(i).W(:,:,j), k) + ...
                tape(tape(i).arg1vc).W(:,j);
        end
    else
        for j = 1 : globp
            tape(tape(i).arg1vc).W(:,j)= diag(tape(i).W(:,:,j)) + ...
                tape(tape(i).arg1vc).W(:,j);
        end
    end
else
    if ~isempty(tape(i).arg2vc)
        k = tape(i).arg2vc;
        for j = 1 : globp
            tape(tape(i).arg1vc).W(:,:,j)= diag(tape(i).W(:,j), k) + ...
                tape(tape(i).arg1vc).W(:,j);
        end
    else
        for j = 1 : globp
            tape(tape(i).arg1vc).W(:,:,j)= diag(tape(i).W(:,j)) + ...
                tape(tape(i).arg1vc).W(:,j);
        end
    end
end


