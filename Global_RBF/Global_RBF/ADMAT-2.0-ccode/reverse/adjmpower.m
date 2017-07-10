function adjmpower(i)
%
%
%   04/2007 -- matrix operation is used to avoid 
%              "for" loop to improve the performance.
%   04/2007 -- consider all cases for tape(i).W is a scalar, row
%              vector, column vector and matrix
%   04/2007 -- completed the programming of 'adjmpower.m'
%
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

global tape;
global globp;

[m,n] = size(tape(i).val);

if ~isempty(tape(i).arg3vc)
    if tape(i).arg3vc==-1                 % tape(i).arg1vc is not an object of derivtape class
        if m == 1 && n==1                  % tape(i).val is a scalar
            val2 = tape(i).val .* log(tape(i).arg1vc);
            tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + ...
                val2.*tape(i).W;
        else                              % tape(i).val is a matrix
            if  length(tape(i).arg1vc) == 1  % tape(i).arg1vc is a scalar
                val2 = tape(i).val .* log(tape(i).arg1vc);
                tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + ...
                    val2(:,:,ones(1,globp)) .* tape(i).W;
            else                          % tape(i).arg1vc is a matrix
                val2 = tape(i).val .* log(tape(i).arg1vc);
                tmp = val2(:,:,ones(1,globp)) .* tape(i).W;
                tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + ...
                    squeeze(sum(sum(tmp)))';
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
        else                              % tape(i).val is a matrix
            if  length(tape(i).arg2vc) == 1  % tape(i).arg2vc is a scalar
                val2 = y .* (x.^(y-1));
                tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W + ...
                    val2(:,:,ones(1,globp)) .* tape(i).W;
            else                          % tape(i).arg2vc is a matrix
                val2 = y .* (x.^(y-1));
                tmp = val2(:,:,ones(1,globp)) .* tape(i).W;
                tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W + ...
                    squeeze(sum(sum(tmp)))';
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
        if length(x) == 1           % x is a saclar and y is a matrix
            tmp =  val1(:,:,ones(1,globp)) .* tape(i).W;
            tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W + ...
                squeeze(sum(sum(tmp)))';
            tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + ...
                val2(:,:,ones(1,globp)).*tape(i).W;
        else                       % y is a scalar and x is a matrix
            tmp =  val2(:,:,ones(1,globp)) .* tape(i).W;
            tape(tape(i).arg1vc).W = tape(tape(i).arg1vc).W + ...
                val1(:,:,ones(1,globp)).*tape(i).W;
            tape(tape(i).arg2vc).W = tape(tape(i).arg2vc).W + ...
                squeeze(sum(sum(tmp)))';
        end
    end
end
