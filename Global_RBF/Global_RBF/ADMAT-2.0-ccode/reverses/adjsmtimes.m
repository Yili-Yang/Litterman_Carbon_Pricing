function adjsmtimes(i)
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

if ~isempty(tape(i).arg3vc)

    if tape(i).arg3vc==-1               % x is not a derivtape object
        x = tape(i).arg1vc;
        y = tape(tape(i).arg2vc).val;
        [m1,n1]=size(x);
        [m2,n2]=size(y);
        if ((m1>1)&&(n1>1))             % x is a matrix
            if m2 > 1 && n2==1                    % y is a vector
                tape(tape(i).arg2vc).W=tape(tape(i).arg2vc).W+...
                    x'*tape(i).W;
            elseif n2 >1                     % y is a matrix
                tape(tape(i).arg2vc).W=tape(tape(i).arg2vc).W+...
                    x'*tape(i).W;
            else                     % y is a scalar
                tape(tape(i).arg2vc).W=tape(tape(i).arg2vc).W+...
                    sum(sum(x'.* tape(i).W));
            end
        else                           % x is a scalar or a  vector
            if (length(x)==1)          % x is a scalar
                tape(tape(i).arg2vc).W=tape(tape(i).arg2vc).W + x.*tape(i).W;
            elseif (length(y)==1)         % x is a vector and y is a scalar
                tape(tape(i).arg2vc).W=tape(tape(i).arg2vc).W+sum(x(:).*tape(i).W);
            else                     % neither x or y is a scalar
                if n2==1 && m2~=1    % y is a column vector
                    % inner product
                    tape(tape(i).arg2vc).W=tape(tape(i).arg2vc).W + x'*tape(i).W;
                elseif m2 == 1 && n2 >1                % outer product
                    tape(tape(i).arg2vc).W=tape(tape(i).arg2vc).W + tape(i).W'* x;
                else
                    tape(tape(i).arg2vc).W=tape(tape(i).arg2vc).W +  x' * tape(i).W';
                end
            end
        end
    else                            % tape(i).arg3vc==-2
        x = tape(tape(i).arg1vc).val;
        y = tape(i).arg2vc;
        [m1,n1]=size(x);
        [m2,n2]=size(y);

        if ((m1>1)&&(n1>1))                     % x is a matrix
            tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W+tape(i).W*y';
        else
            if (length(x)==1)                    % x is a scalar
                if m2==1 || n2==1                  % y is a vector
                    tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W+sum(y(:).*tape(i).W);
                else                             % y is a matrix
                    tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W+sum(sum(y.*tape(i).W));
                end
            elseif (length(y)==1)
                tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W + y.*tape(i).W;
            else                       % neither x or y is a scalar
                if n1==1 && m1~=1            % x is a column vector
                    % outer product
                    tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W+tape(i).W*y(:);
                elseif m2 >1 && n2 >1         % y is a matrix
                    tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W + y*tape(i).W;
                else                        % inner product
                    tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W+y*tape(i).W;
                end
            end
        end

    end

else              % both are derivtape objects
    x = tape(tape(i).arg1vc).val;
    y = tape(tape(i).arg2vc).val;
    [m1,n1]=size(x);
    [m2,n2]=size(y);

    if ((m1>1) && (n1>1))                 % x is a matrix
        if m2 > 1 && n2==1                % y is a column vector
            tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W + ...
                tape(i).W * y';
            tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + ...
                x' * tape(i).W;
        elseif m2 > 1 && n2 > 1          % y is a matrix
            tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W + ...
                tape(i).W * y';
            tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + ...
                x' * tape(i).W;
        else                            % y is a scalar
            tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W + ...
                tape(i).W * y;
            tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + ...
                sum(sum(x' .* tape(i).W));
        end
    else
        if (length(x)==1)                   % x is a scalar
            if m==1 || n==1
                tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W + ...
                    sum(y(:).*tape(i).W);
                tape(tape(i).arg2vc).W=tape(tape(i).arg2vc).W + ...
                    x.*tape(i).W;
            else
                tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W + ...
                    sum(sum(y' .* tape(i).W));
                tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + ...
                    x.*tape(i).W;

            end
        elseif (length(y)==1)                   % y is a scalar
            if m==1 || n==1
                tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W + ...
                    y.*tape(i).W;
                tape(tape(i).arg2vc).W=tape(tape(i).arg2vc).W + ...
                    sum(x(:).*tape(i).W);
            else
                tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W + ...
                    y.*tape(i).W;
                tape(tape(i).arg2vc).W=tape(tape(i).arg2vc).W + ...
                    sum(sum(x'.*tape(i).W));
            end
        else                   % neither x or y is scalar, x is a vector
            if n1==1 && m1~=1     % x is a column vetor
                % outer product
                tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W + ...
                    (y * tape(i).W)';
                tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + ...
                    tape(i).W'*x;
            elseif m2 > 1 && n2 > 1      % x is a row vector while y is a matrix
                tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W + ...
                    y*tape(i).W;
                tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + ...
                    (tape(i).W*x)';
            else                      % inner product
                tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W + ...
                    y * tape(i).W;
                tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + ...
                    x'*tape(i).W;
            end
        end
    end
end
