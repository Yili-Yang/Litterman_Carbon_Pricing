function adjldivide(i)
%
%
%   03/2007 -- matrix operation is used to avoid 
%              "for" loop to improve the performance.
%   03/2007 -- consider all cases for tape(i).W is a scalar, row
%              vector, column vector and matrix
%   03/2007 -- correct the computation of derivatives of ldivide.
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
        tmp = 1./x;
        if (length(x)==1)                    % x is a scalar.
            tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + tmp .* tape(i).W;
        elseif (length(y)==1)                % y is a scalar
            if (m==1) || (n==1)              % tape(i).val is a vector
                if n == 1                   % column vector
                    tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + ...
                        sum(tmp(:,ones(1,globp)) .* tape(i).W);
                else
                    tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + ...
                        sum(tmp(ones(globp,1),:)' .* tape(i).W);
                end
            else                             % tape(i).val is a matrix
                tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W+...
                    squeeze(sum(sum(tmp(:,:,ones(1,globp)) .* tape(i).W)))';
            end
        else                              % neither x nor y is a scalar
            if m == 1 || n == 1
                if n == 1                 % column vector
                    tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + ...
                        tmp(:,ones(1,globp)) .* tape(i).W;
                else
                    tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + ...
                        tmp(ones(globp,1),:)' .* tape(i).W;
                end
            else
                tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W+...
                    tmp(:,:,ones(1,globp)) .* tape(i).W;
            end
        end
    else                            % y is not a derivtape object
        x = tape(tape(i).arg1vc).val;
        y = tape(i).arg2vc;
        tmp = - tape(i).val ./ x;
        if (length(y)==1)                      % y is a scalar
            if m == 1 && n == 1                 % tape(i).val is a scalar
                  tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W + ...
                      tmp .* tape(i).W;
            elseif m==1 || n ==1               % tape(i).val is a vector
                if n == 1                % column vector
                    tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W + ...
                        tmp(:,ones(1,globp)) .* tape(i).W;
                else
                    tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W + ...
                        tmp(ones(globp,1),:)' .* tape(i).W;
                end
            else                              % tape(i).val is a matrix
                 tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W + ...
                      tmp(:,:,ones(1,globp)) .* tape(i).W;
            end
        elseif length(x) == 1               % x is a scalar, y is not a scalar
            if (m==1) || (n==1)             % tape(i).val is a vector
                if n == 1
                    tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W+...
                        sum(tmp(:,ones(1,globp)).* tape(i).W);
                else
                    tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W+...
                        sum(tmp(ones(globp,1),:)'.* tape(i).W);
                end
            else                            % tape(i).val is a matrix
                tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W+...
                    squeeze(sum(sum(tmp(:,:,ones(1,globp)) .* tape(i).W)))';
            end
        else                             % neither x nor y is a scalar
            if m == 1 || n == 1
                if n == 1
                    tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W+...
                        tmp(:,ones(1,globp)).* tape(i).W;
                else
                    tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W+...
                        tmp(ones(globp,1),:)'.* tape(i).W;
                end
            else                         % tape(i).val is a matrix
                tape(tape(i).arg1vc).W =tape(tape(i).arg1vc).W + ...
                    tmp(:,:,ones(1,globp)) .* tape(i).W;
            end
        end
    end
    
else                                        % both are derivtape objects  
    
    x = tape(tape(i).arg1vc).val;
    y = tape(tape(i).arg2vc).val;
    tmp1 = - tape(i).val ./ x;
    tmp2 = 1./x;
    if (length(x)==1)                        % x is a scalar
        if m == 1 && n ==1
            tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W+...
                tmp1 .* tape(i).W;
            tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + ...
                tmp2 .* tape(i).W;
        else
            if (m==1) || (n==1)                  % tape(i).val is a vector
                if n == 1                      % column vector
                    tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W + ...
                        sum(tmp1(:,ones(1,globp)) .* tape(i).W);
                    tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W +...
                        tmp2 .* tape(i).W;
                else
                    tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W + ...
                        sum(tmp1(ones(globp,1),:)' .* tape(i).W);
                    tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W +...
                        tmp2 .* tape(i).W;
                end
            else                                 % tape(i).val is a matrix
                tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W + ...
                    squeeze(sum(sum(tmp1(:,:,ones(1,globp)) .* tape(i).W)))';
                tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W +...
                    tmp2 .* tape(i).W;
            end
        end
    elseif (length(y)==1)                 % y is a scalar and x is not
        if (m==1) || (n==1)               % tape(i).val is a vector
            if n == 1
                tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W +...
                    tmp1(:,ones(1,globp)).*tape(i).W;
                tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W+...
                    sum(tmp2(:,ones(1,globp)) .* tape(i).W);
            else
                tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W +...
                    tmp1(ones(globp,1),:)'.*tape(i).W;
                tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W+...
                    sum(tmp2(ones(globp,1),:)' .* tape(i).W);
            end
        else                              % tape(i).val is a matrix
            tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W + ...
                tmp1(:,:,ones(1,globp)) .* tape(i).W;
            tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W+...
                squeeze(sum(sum(tmp2(:,:,ones(1,globp)) .* tape(i).W)))';
        end
    else                                % neithe x nor y is a scalar
        if m == 1 || n == 1
            if n == 1
                tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W + ...
                    tmp1(:,ones(1,globp)) .* tape(i).W;
                tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W +...
                    tmp2(:,ones(1,globp)) .* tape(i).W;
            else
                tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W + ...
                    tmp1(ones(globp,1),:)' .* tape(i).W;
                tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W +...
                    tmp2(ones(globp,1),:)' .* tape(i).W;
            end
        else                            % tape(i).val is a matrix
            tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W + ...
                tmp1(:,:,ones(1,globp)) .* tape(i).W;
            tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W +...
                tmp2(:,:,ones(1,globp)) .* tape(i).W;
        end
    end
end
