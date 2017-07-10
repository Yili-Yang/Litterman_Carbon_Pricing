function adjpower(i)
%
%   devolped by Arun
%   revised by Wei Xu, 04/2007
%
%   04/2007 -- matrix operation is used to avoid 
%              "for" loop to improve the performance.
%   04/2007 -- consider all cases for tape(i).W is a scalar, row
%              vector, column vector and matrix
%   04/2007 -- completed the programming of 'adjpower.m'
%
global tape;
global globp;

[m,n] = size(tape(i).val);

if ~isempty(tape(i).arg3vc)
    if tape(i).arg3vc == -1                 % x is not an object of derivtape class
        x = tape(i).arg1vc;           
        if m == 1 && n==1                  % tape(i).val is a scalar
            val2 = tape(i).val .* log(x);
            tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + ...
                val2.*tape(i).W;
        else        
            if m == 1 || n == 1
                val2 = tape(i).val .* log(x);
                val2 = val2(:);
                if length(tape(tape(i).arg2vc).val) == 1
                    tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + ...
                         sum(val2(:,ones(1,globp)) .* tape(i).W);   
                else
                tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + ...
                    val2(:,ones(1,globp)) .* tape(i).W;       
                end
            else                          % tape(i).arg1vc is a matrix
                val2 = tape(i).val .* log(x);
                tmp = val2(:,:,ones(1,globp)) .* tape(i).W;
                if length(tape(tape(i).arg2vc).val) == 1
                    tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W +...
                        squeeze(sum(sum(tmp)))';
                else
                    tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + tmp;
                end
            end
        end
    else                                 % tape(i).arg2vc is not an object of derivtape class
        %  tape(i).arg3vc == -2
        x = tape(tape(i).arg1vc).val;
        y = tape(i).arg2vc;
        if m == 1 && n==1                  % tape(i).val is a scalar
            val2 = y .* (x.^(y-1));
            tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W + ...
                val2.*tape(i).W;
        else                              
            if m == 1 || n == 1
                val2 = y .* (x.^(y-1));
                val2 = val2(:);
                if length(x) == 1
                    tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W + ...
                        sum(val2(:,ones(1,globp)) .* tape(i).W);
                else
                    tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W + ...
                        val2(:,ones(1,globp)) .* tape(i).W;
                end
            else                          % tape(i).val is a matrix
                val2 = y .* (x.^(y-1));
                tmp = val2(:,:,ones(1,globp)) .* tape(i).W;
                if length(x) == 1
                    tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W +...
                        squeeze(sum(sum(tmp)))';
                else
                    tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W + tmp;
                end
            end
        end
    end
else      % both tape(i).arg2vc and tape(i).arg1vc are derivtape objects

    x = tape(tape(i).arg1vc).val;
    y = tape(tape(i).arg2vc).val;
    val1 = y .* (x.^(y-1));
    val2 = tape(i).val .* log(x);
    if m ==1 && n ==1     % tape(i).val is  a scalar
        tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W + ...
            val1.*tape(i).W;
        tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + ...
            val2.*tape(i).W;
    else
        if m == 1 || n == 1
            val1 = val1(:);
            tmp =  val1(:,ones(1,globp)) .* tape(i).W;
            if length(x) == 1                    % x is a scalar
                tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W + sum(tmp);
            else                                 % x is a vector
                tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W + tmp;
            end
            val2 = val2(:);
            tmp =  val2(:,ones(1,globp)) .* tape(i).W;
            if length(y) == 1                   % y is a scalar
                tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + sum(tmp);
            else
                tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + tmp;
            end
        else                       % tape(i).val is a matrix
            if length(x) == 1
                tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W + ...
                    squeeze(sum(sum(val1(:,:,ones(1,globp)).*tape(i).W)))';
            else
                tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W + ...
                    val1(:,:,ones(1,globp)).*tape(i).W;
            end
            if length(y) == 1
                tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + ...
                    squeeze(sum(sum(val2(:,:,ones(1,globp)).*tape(i).W)))';
            else
                tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + ...
                    val2(:,:,ones(1,globp)).*tape(i).W;
            end
        end
    end
end
