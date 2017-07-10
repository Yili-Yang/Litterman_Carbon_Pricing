function adjsmpower(i)
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************
%
global tape;

if ~isempty(tape(i).arg3vc)

    if tape(i).arg3vc == -1
        tmp = tape(i).val .* log(tape(i).arg1vc);
        if length(tape(tape(i).arg2vc).W) == 1         % scalar
            tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + ...
                sum(sum(tmp .* tape(i).W));
        else                                           % matrix
            tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + ...
                tmp .* tape(i).W;
        end
    else             % tape(i).arg3vc == -2
        tmp =  tape(i).arg2vc.*(tape(tape(i).arg1vc).val.^(tape(i).arg2vc-1));
        if length(tape(tape(i).arg1vc).W) == 1
            tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W + ....
                sum(sum(tmp.*tape(i).W));
        else
            tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W + ....
                tmp.*tape(i).W;
        end

    end

else     % both are derivtape objects
    x = tape(tape(i).arg1vc).val;
    y = tape(tape(i).arg2vc).val;
    tmp1 = tape(i).val .* log(x);
    tmp2 = y.*(x.^(y-1));
    if length(y) == 1                  % y is a scalar
        tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + ...
            sum(sum(tmp1 .* tape(i).W));
    else
        tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + ...
            tmp1 .* tape(i).W;
    end
    if length(x) == 1                % x is a scalar
        tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W + ....
            sum(sum(tmp2.*tape(i).W));
    else
        tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W + ....
            tmp2.*tape(i).W;
    end
end

