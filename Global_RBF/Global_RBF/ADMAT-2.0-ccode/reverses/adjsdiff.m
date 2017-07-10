function adjdiff(i)
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

%
%                 Wei Xu
%              Otc. 31, 2012
%
global tape;
global globp;

[m,n] = size(tape(i).val);
if globp > 1
    if m > 1 && n >1  % val is a matrix
        tape(tape(i).arg1vc).W(2:end,:,:) = tape(tape(i).arg1vc).W(2:end,:,:)...
          + tape(i).W;
         tape(tape(i).arg1vc).W(1:end-1,:,:) = tape(tape(i).arg1vc).W(1:end-1,:,:)...
          - tape(i).W;
    elseif m>1 && n==1  % val is a column vector
         tape(tape(i).arg1vc).W(2:end,:) = tape(tape(i).arg1vc).W(2:end,:)...
          + tape(i).W;
          tape(tape(i).arg1vc).W(1:end-1,:) = tape(tape(i).arg1vc).W(1:end-1,:)...
                - tape(i).W;
    elseif m==1 && n>1   % val is a row vector
        if length(size(tape(tape(i).arg1vc).W)) == 3  % the original input is a matrix, but output is a row vector
            for j = 1: globp
                 tape(tape(i).arg1vc).W(2,:,j) = tape(tape(i).arg1vc).W(2,:,j)...
                   + tape(i).W;
                 tape(tape(i).arg1vc).W(1,:,j) = tape(tape(i).arg1vc).W(1,:,j)...
                   - tape(i).W;
            end
        else                
         tape(tape(i).arg1vc).W(2:end,:) = tape(tape(i).arg1vc).W(2:end,:)...
          + tape(i).W;
          tape(tape(i).arg1vc).W(1:end-1,:) = tape(tape(i).arg1vc).W(1:end-1,:)...
                - tape(i).W;
        end
    else   % val is a scalar
        tape(tape(i).arg1vc).W(2:end) = tape(tape(i).arg1vc).W(2:end)...
          + tape(i).W;
          tape(tape(i).arg1vc).W(1:end-1) = tape(tape(i).arg1vc).W(1:end-1)...
                - tape(i).W;
    end
else    % globp == 1
    if m > 1 && n >1  % val is a matrix
        tape(tape(i).arg1vc).W(2:end,:) = tape(tape(i).arg1vc).W(2:end,:)...
          + tape(i).W;
         tape(tape(i).arg1vc).W(1:end-1,:) = tape(tape(i).arg1vc).W(1:end-1,:)...
          - tape(i).W;
    elseif m>1 && n==1  % val is a column vector
         tape(tape(i).arg1vc).W(2:end,:) = tape(tape(i).arg1vc).W(2:end,:)...
          + tape(i).W;
          tape(tape(i).arg1vc).W(1:end-1,:) = tape(tape(i).arg1vc).W(1:end-1,:)...
                - tape(i).W;
    elseif m==1 && n>1   % val is a row vector
        if (size(tape(tape(i).arg1vc).W,2)) > 1  % the original input is a matrix, but output is a row vector
            for j = 1: globp
                 tape(tape(i).arg1vc).W(2,:,j) = tape(tape(i).arg1vc).W(2,:,j)...
                   + tape(i).W;
                 tape(tape(i).arg1vc).W(1,:,j) = tape(tape(i).arg1vc).W(1,:,j)...
                   - tape(i).W;
            end
        else                
         tape(tape(i).arg1vc).W(2:end) = tape(tape(i).arg1vc).W(2:end)...
          + tape(i).W;
          tape(tape(i).arg1vc).W(1:end-1) = tape(tape(i).arg1vc).W(1:end-1)...
                - tape(i).W;
        end
    else   % val is a scalar
        tape(tape(i).arg1vc).W(2:end) = tape(tape(i).arg1vc).W(2:end)...
          + tape(i).W;
          tape(tape(i).arg1vc).W(1:end-1) = tape(tape(i).arg1vc).W(1:end-1)...
                - tape(i).W;
    end
end