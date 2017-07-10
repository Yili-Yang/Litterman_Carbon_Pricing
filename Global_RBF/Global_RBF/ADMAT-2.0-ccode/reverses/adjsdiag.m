function adjsdiag(i)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global tape;

V = tape(tape(i).arg1vc).val;
[m,n] = size(V);

if m == 1 || n == 1
    if ~isempty(tape(i).arg2vc)
        k = tape(i).arg2vc;
            tape(tape(i).arg1vc).W(:,1)= diag(tape(i).W, k) + ...
                tape(tape(i).arg1vc).W(:,1);
    else
            tape(tape(i).arg1vc).W(:,1)= diag(tape(i).W) + ...
                tape(tape(i).arg1vc).W(:,1);
    end
else
    if ~isempty(tape(i).arg2vc)
        k = tape(i).arg2vc;
            tape(tape(i).arg1vc).W= diag(tape(i).W(:,1), k) + ...
                tape(tape(i).arg1vc).W(:,1);
    else

            tape(tape(i).arg1vc).W= diag(tape(i).W(:,1)) + ...
                tape(tape(i).arg1vc).W(:,1);
    end
end
