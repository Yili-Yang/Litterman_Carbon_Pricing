function adjmtimes(i)
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
global globp;
[m,n]=size(tape(i).val);

if ~isempty(tape(i).arg3vc)                  % one of operands is not derivtape objects

    if tape(i).arg3vc == -1                  % tape(i).arg1vc is not a derivtape object
        x = tape(i).arg1vc;
        y = tape(tape(i).arg2vc).val;
        if (length(x)==1)                    % x is a scalar.
            tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W+...
                tape(i).arg1vc .* tape(i).W;
        elseif (length(y)==1)                % y is a scalar
            if (m==1) || (n==1)              % tape(i).val is a vector
                tmp = tape(i).arg1vc(:);
                tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W+...
                    sum(tmp(:,ones(1,globp)) .* tape(i).W);
            else                             % tape(i).val is a matrix
                tmp = tape(i).arg1vc;
                tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W+...
                    squeeze(sum(sum(tmp(:,:,ones(1,globp)) .* tape(i).W)))';
            end
        else                              % neither x nor y is a scalar
            if m ==1 && n==1          % inner product
                tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W+...
                    x' * tape(i).W;
            else
                if size(y,1) == 1 && m >1 && n>1        % outer product
                    tmp = x(:, ones(1,n));
                    tmp = tmp(:,:,ones(1,globp));
                    tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W+...
                        squeeze(sum(tmp .* tape(i).W));
                else      
                    if m == 1 && n > 1    % x is a row vector and y is a matrix
                        tmp = x(ones(globp,1),:);
                        tmp = tmp(:,:,ones(1,n));
                        tmp = permute(tmp, [2,3,1]);
                        tmp1 = tape(i).W(:,:,ones(1, length(x)));
                        tmp1 = permute(tmp1,[3,1,2]);
                        tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + ...
                            tmp .* tmp1;
                    else
                        if m >1 && n == 1      % x is a matrix and y is a column vector
                            tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + ...
                                x' * tape(i).W;
                        else
                            % both x and y are matrices
                            for j = 1 : globp
                                tape(tape(i).arg2vc).W(:,:,j) = tape(tape(i).arg2vc).W(:,:,j)+...
                                    x' * tape(i).W(:,:,j);
                            end
                        end
                    end
                end
            end
        end

    else                            % y is not a derivtape object
        x = tape(tape(i).arg1vc).val;
        y = tape(i).arg2vc;
        if (length(y)==1)          % y is a scalar
            tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W+...
                y .* tape(i).W;
        elseif length(x) == 1               % x is a scalar
            if (m==1) || (n==1)             % tape(i).val is a vector
                tmp = y(:);
                tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W+...
                    sum(tmp(:,ones(1,globp)) .* tape(i).W);
            else                            % tape(i).val is a matrix
                tmp = y;
                tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W+...
                    squeeze(sum(sum(tmp(:,:,ones(1,globp)) .* tape(i).W)))';
            end
        else                             % neither x nor y is a scalar
            if (m==1) && (n==1)          % inner product
                tape(tape(i).arg1vc).W =tape(tape(i).arg1vc).W + y*tape(i).W;
            else
                if size(y,1) == 1 && m >1 && n>1         %outer product
                    tmp = y(ones(globp,1),:);
                    tmp = tmp(:,:,ones(1,m));
                    tmp = permute(tmp, [3,2,1]);
                    tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W + ...
                       squeeze(sum(tmp.*tape(i).W));
                else
                    if m == 1 && n >1         %  x is a row vector and y is a matrix
                        tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W + ...
                            y*tape(i).W;
                    else                     %  x is a matrix and y is a column vector
                        if m > 1 && n ==1
                            tmp = y(:, ones(1, globp));
                            tmp = tmp(:,:,ones(1,m));
                            tmp = permute(tmp, [3,1,2]);
                            tmp2 = tape(i).W(:,:,ones(1,length(y)));
                            tmp2 = permute(tmp2,[1,3,2]);
                            tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W + ...
                                tmp .* tmp2;
                        else
                            % both x and y are matrices
                            for j = 1 : globp
                                tape(tape(i).arg1vc).W(:,:,j) = tape(tape(i).arg1vc).W(:,:,j) + ...
                                    tape(i).W(:,:,j) * y;
                            end
                        end
                    end
                end
            end
        end
    end

else                                        % both are derivtape objects
    x = tape(tape(i).arg1vc).val;
    y = tape(tape(i).arg2vc).val;
    if (length(x)==1)                        % x is a scalar
        if (m == 1)  && n == 1
            tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W+...
                 y .* tape(i).W;
             tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + x.*tape(i).W;
        elseif (m==1) || (n==1)                  % tape(i).val is a vector
            tmp = y(:);
            tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W+...
                sum(tmp(:,ones(1,globp)) .* tape(i).W);
            tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + x.*tape(i).W;
        else                                 % tape(i).val is a matrix
            tmp = y;
            tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W+...
                squeeze(sum(sum(tmp(:,:,ones(1,globp)) .* tape(i).W)))';
            tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + x .* tape(i).W;
        end
    elseif (length(y)==1)                 % y is a scalar
        if (m==1) || (n==1)
            tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W+y.*tape(i).W;
            tmp = x(:);
            tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W+...
                sum(tmp(:,ones(1,globp)) .* tape(i).W);
        else                              % tape(i).val is a matrix
            tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W+y.*tape(i).W;
            tmp = x;
            tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W+...
                squeeze(sum(sum(tmp(:,:,ones(1,globp)) .* tape(i).W)))';
        end
    else                                % neithe x nor y is a scalar
        if (m==1) && (n==1)             % inner product
            tmp = y(:);
            tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W + tmp*tape(i).W;
            tape(tape(i).arg2vc).W=tape(tape(i).arg2vc).W + x(:)*tape(i).W;
        else
            if m == 1 && n > 1           % tape(i).val is a row vector
                tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W + y*tape(i).W;
                tmp = x(ones(globp,1), :);
                tmp = tmp(:,:, ones(1,n));
                tmp = permute(tmp, [2,3,1]);
                len = length(x);
                tmp1 = tape(i).W(:,:,ones(1, len));
                tmp1 = permute(tmp1,[3,1,2]);
                 tape(tape(i).arg2vc).W=tape(tape(i).arg2vc).W +...
                     tmp .* tmp1;
            else
                if m > 1 && n == 1      % tape(i).val is a column vector
                    tmp = y(:, ones(1,globp));
                    tmp = tmp(:,:, ones(1,m));
                    tmp = permute(tmp, [3,1,2]);
                    len = length(y);
                    tmp1 = tape(i).W(:,:,ones(1,len));
                    tmp1 = permute(tmp1, [1,3,2]);
                    tape(tape(i).arg1vc).W=tape(tape(i).arg1vc).W +...
                        tmp .* tmp1;
                    tape(tape(i).arg2vc).W=tape(tape(i).arg2vc).W + x' * tape(i).W;
                else
                    if size(y,1) == 1           % outer product
                        tmp = y(ones(globp,1),:);
                        tmp = tmp(:,:,ones(1,m));
                        tmp = permute(tmp, [3,2,1]);
                        tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W + ...
                            squeeze(sum(tmp.*tape(i).W,2));
                        tmp = x(:, ones(1,globp));
                        tmp = tmp(:,:,ones(1,n));
                        tmp = permute(tmp, [1,3,2]);
                        tmp = sum(tmp .* tape(i).W);
                        if ( length(size(tmp)) ==2 && size(tmp,1) == 1)
                            tmp = tmp(:);
                        end
                        tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W+...
                            squeeze(tmp);
                    else                       % both are matrices
                        for j = 1 : globp
                            tape(tape(i).arg1vc).W(:,:,j) = tape(tape(i).arg1vc).W(:,:,j) + ...
                                tape(i).W(:,:,j)*y';
                            tape(tape(i).arg2vc).W(:,:,j) = tape(tape(i).arg2vc).W(:,:,j) +...
                                x' * tape(i).W(:,:,j);
                        end
                    end
                end
            end
        end
    end
end
