function adjtranspose(i)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global tape;
global globp;

[m,n]=size(tape(i).val);

if m==1 && n==1               % tape(i).val is a scalar
    tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W + ...
                               tape(i).W;
else
    if m == 1                 % tape(i).val is a row vector
        tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W + ...
                                  tape(i).W;
    else
        if n == 1               % tape(i).val is a column vector
            tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W + ...
                                       tape(i).W;
 
        else                   % tape(i).val is a matrix
            for j = 1 : globp
                tape(tape(i).arg1vc).W(:,:,j) = ...
                   tape(tape(i).arg1vc).W(:,:,j) + tape(i).W(:,:,j).';
            end
        end
    end
end
