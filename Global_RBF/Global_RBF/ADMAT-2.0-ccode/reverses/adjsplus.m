function adjsplus(i)

%
%
%  04/2007 -- rearrage the program for readibilty
%  04/2007 -- correct the computation of derivative
% 
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global tape;

[m,n] = size(tape(i).val);
if ~isempty(tape(i).arg3vc)
    if tape(i).arg3vc == -1
        y = tape(tape(i).arg2vc).val;
        [m2, n2] = size(y);
        if m2 == 1 && n2 == 1
            if m == 1 || n == 1
                tape(tape(i).arg2vc).W=tape(tape(i).arg2vc).W + ...
                    sum(tape(i).W);
            else
                tape(tape(i).arg2vc).W=tape(tape(i).arg2vc).W + ...
                    sum(sum(tape(i).W));
            end
        else
            tape(tape(i).arg2vc).W=tape(tape(i).arg2vc).W+tape(i).W;
        end
    else
        x = tape(tape(i).arg1vc).val;
        [m1,n1] = size(x);
        if m1 == 1 && n1 == 1
            if m == 1 || n == 1
                tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W + ...
                    sum(tape(i).W);
            else
                tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W + ...
                    sum(sum(tape(i).W));
            end
        else
            tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W+tape(i).W;
        end
    end
else
    x = tape(tape(i).arg1vc).val;
    [m1,n1]=size(x);
    y = tape(tape(i).arg2vc).val;
    [m2, n2] = size(y);
    if ((m1==1) && (n1 ==1))
        if m2 ==1 || n2 == 1
            tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W+sum(tape(i).W);
            tape(tape(i).arg2vc).W=tape(tape(i).arg2vc).W+tape(i).W;
        else
            tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W + ...
                sum(sum(tape(i).W));
            tape(tape(i).arg2vc).W=tape(tape(i).arg2vc).W+tape(i).W;
        end
    elseif m1 == 1 || n1 == 1
        if m2 == 1 && n2 == 1
            tape(tape(i).arg2vc).W=tape(tape(i).arg2vc).W + ...
                sum(tape(i).W);
        else
            tape(tape(i).arg2vc).W=tape(tape(i).arg2vc).W + tape(i).W;
        end
        tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W+tape(i).W;
    else                    % x is a matrix
        if m2 == 1 && n2 == 1
            tape(tape(i).arg2vc).W=tape(tape(i).arg2vc).W + ...
                sum(sum(tape(i).W));
        else
            tape(tape(i).arg2vc).W=tape(tape(i).arg2vc).W+tape(i).W;
        end
        tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W+tape(i).W;
    end
end