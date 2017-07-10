function adjplus(i)
%
%
%   04/2007 -- matrix operation is used to avoid 
%              "for" loop to improve the performance.
%   04/2007 -- consider all cases for tape(i).W is a scalar, row
%              vector, column vector and matrix
%   04/2007 -- correct the computation of derivatives of asech(x).
%
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************


global tape;
[m,n]=size(tape(i).val);

if ~isempty(tape(i).arg3vc)                  % one of operands is not derivtape objects

    if tape(i).arg3vc == -1                  % tape(i).arg1vc is not a derivtape object
        x = tape(i).arg1vc;
        y = tape(tape(i).arg2vc).val;
        if (length(x)==1)                    % x is a scalar.
            tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + tape(i).W;
        elseif (length(y)==1)                % y is a scalar
            if (m==1) || (n==1)              % tape(i).val is a vector
                tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + sum(tape(i).W);
            else                             % tape(i).val is a matrix
                tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W+...
                    squeeze(sum(sum(tape(i).W)))';
            end
        else                              % neither x nor y is a scalar
            tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + tape(i).W;
        end
    else                            % y is not a derivtape object
        x = tape(tape(i).arg1vc).val;
        y = tape(i).arg2vc;
        if (length(y)==1)          % y is a scalar
            tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W+tape(i).W;
        elseif length(x) == 1               % x is a scalar
            if (m==1) || (n==1)             % tape(i).val is a vector
                tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W+...
                    sum(tape(i).W);
            else                            % tape(i).val is a matrix
                tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W+...
                    squeeze(sum(sum(tape(i).W)))';
            end
        else                             % neither x nor y is a scalar
            tape(tape(i).arg1vc).W =tape(tape(i).arg1vc).W + tape(i).W;
        end
    end
    
else                                        % both are derivtape objects  
    
    x = tape(tape(i).arg1vc).val;
    y = tape(tape(i).arg2vc).val;
    if m == 1 && n == 1
        tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W+...
            tape(i).W;
        tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + tape(i).W;
    else
        if (length(x)==1)                        % x is a scalar
            if (m==1) || (n==1)                  % tape(i).val is a vector
                tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W+...
                    sum(tape(i).W);
                tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + tape(i).W;
            else                                 % tape(i).val is a matrix
                tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W+...
                    squeeze(sum(sum(tape(i).W)))';
                tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + tape(i).W;
            end
        elseif (length(y)==1)                 % y is a scalar
            if (m==1) || (n==1)               % tape(i).val is a vector
                tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W + tape(i).W;
                tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W+...
                    sum(tape(i).W);
            else                              % tape(i).val is a matrix
                tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W + tape(i).W;
                tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W+...
                    squeeze(sum(sum(tape(i).W)))';
            end
        else                                % neithe x nor y is a scalar
            tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W + tape(i).W;
            tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + tape(i).W;
        end
    end
end
