function adjsldivide(i)
%
%
%  04/2007 -- consider the case for row vectors
%  04/2007 -- correct the computation of derivative
% 
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global tape;

[m,n]=size(tape(i).val);
if ~isempty(tape(i).arg3vc)   % one of oprands is not a derivtape object
    if tape(i).arg3vc == -1   % tape(i).arg1vc is not a derivtape object
        x = tape(i).arg1vc;
        y = tape(tape(i).arg2vc).val;
        [m2, n2] = size(y);
        tmp = 1./x;
        if m == 1 || n == 1
            if m2 == 1 && n2 == 1
                tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + ...
                    sum(tmp(:) .* tape(i).W);
            else
                tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + ...
                    tmp(:) .* tape(i).W;
            end
        else
            if m2 == 1 && n2 == 1
                tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + ...
                    sum(sum(tmp .* tape(i).W));
            else
                tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + ...
                    tmp .* tape(i).W;
            end
        end
    elseif tape(i).arg3vc == -2  % tape(i).arg2vc is not a derivtape object
        x = tape(tape(i).arg1vc).val;
        y = tape(i).arg2vc;
        [m1, n1] = size(x);
        tmp = -y./(x.^2);
        if m == 1 || n == 1
            if m1 == 1 && n1 == 1
                tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W + ...
                    sum(tmp(:) .* tape(i).W);
            else
                tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W + ...
                    tmp(:) .* tape(i).W;
            end
        else
            if m1 == 1 && n1 == 1
                tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W + ...
                    sum(sum(tmp .* tape(i).W));
            else
                tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W + ...
                    tmp .* tape(i).W;
            end
        end
    end
else                      % both are derivtape objects
    x = tape(tape(i).arg1vc).val;
    y = tape(tape(i).arg2vc).val;
    [m1, n1] = size(x);
    [m2, n2] = size(y);
    tmp1 = 1./x;
    tmp2 = -y./(x.^2);
    if m == 1 || n == 1
        if m1 == 1 && n1 == 1
            tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W+...
                sum(tmp2(:) .* tape(i).W);
        else
            tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W+...
                tmp2(:) .* tape(i).W;
        end
        if m2 == 1 && n2 == 1
            tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + ...
                sum(tmp1(:) .* tape(i).W);
        else
            tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + ...
                tmp1(:) .* tape(i).W;
        end
    else
        if m1 == 1 && n1 == 1
            tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W+...
            sum(sum(tmp2 .* tape(i).W));
        else
        tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W+...
            tmp2 .* tape(i).W;
        end
        if m2 == 1 && n2 == 1
            tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + ...
                sum(sum(tmp1 .* tape(i).W));
        else
            tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + ...
                tmp1 .* tape(i).W;
        end
    end
end
